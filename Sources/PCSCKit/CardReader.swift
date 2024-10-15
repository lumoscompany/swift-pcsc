//
//  Created by Adam Stragner
//

import Essentials
import PCSC

// MARK: - CardReader

public final class CardReader {
    // MARK: Lifecycle

    init(session: ReaderSession, name: SCardReaderName, drivers: [PeripheralDeviceDriver.Type]) {
        self.name = name
        self.driver = drivers.filter({
            let anyDriver = AnyPeripheralDeviceDriver($0)
            return anyDriver.deviceSearchNames
                .map({ $0.lowercased() })
                .contains(name.rawValue.lowercased())
        }).first ?? _PeripheralDeviceDriver.self

        self.session = session
    }

    // MARK: Public

    public let name: SCardReaderName
    public let driver: PeripheralDeviceDriver.Type

    // MARK: Internal

    let session: ReaderSession
}

// MARK: Equatable

extension CardReader: Equatable {
    public static func == (lhs: CardReader, rhs: CardReader) -> Bool {
        lhs.name == rhs.name
    }
}

// MARK: Hashable

extension CardReader: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

// MARK: Sendable

extension CardReader: Sendable {}

// MARK: CardReader.TimoutError

public extension CardReader {
    func poll<P>(
        _ type: P.Type,
        with timeout: TimeInterval = 15
    ) async throws (ReaderError) -> P? where P: PICC {
        let hContext = session.hContext

        let dwTimeout = TimeInterval(0.5)
        var dwTimeouts = Int(timeout / dwTimeout)

        while dwTimeouts > 0 {
            do throws (SCardError) {
                guard !Task.isCancelled
                else {
                    break
                }

                dwTimeouts -= 1

                var states = [SCardReaderState(szReader: name)]
                try await _SCardGetStatusChange(hContext, dwTimeout, &states)
                try? await Task.sleep(nanoseconds: UInt64(dwTimeout * 1_000_000_000))

                guard let state = states.first, state.dwEventState.contains(.present)
                else {
                    continue
                }

                let connection = try SCardConnect(hContext, name, .shared, [.t0, .t1])
                let unit = try await Unit(
                    reader: self,
                    driver: driver.init(),
                    hCard: connection.phCard,
                    pwProtocol: connection.pdwActiveProtocol
                )

                guard let picc = P(rawValue: unit)
                else {
                    continue
                }

                unit.driver.didConnect(to: picc)
                return picc
            } catch {
                throw .hardware(error)
            }
        }

        return nil
    }
}

public extension CardReader {
    func waitDisconnection(
        with timeout: TimeInterval = 15
    ) async throws (ReaderError) {
        let hContext = session.hContext

        let dwTimeout = TimeInterval(0.5)
        var dwTimeouts = Int(timeout / dwTimeout)

        while dwTimeouts > 0 {
            do throws (SCardError) {
                guard !Task.isCancelled
                else {
                    break
                }

                dwTimeouts -= 1

                var states = [SCardReaderState(szReader: name)]
                try await _SCardGetStatusChange(hContext, dwTimeout, &states)

                guard let state = states.first, state.dwEventState.contains(.empty)
                else {
                    continue
                }

                break
            } catch {
                throw .hardware(error)
            }
        }
    }
}

private extension CardReader {
    @SynchronousActor
    func _SCardGetStatusChange(
        _ hContext: SCardContext,
        _ dwTimeout: TimeInterval,
        _ rgReaderStates: inout [SCardReaderState]
    ) throws (SCardError) {
        try SCardGetStatusChange(hContext, dwTimeout, &rgReaderStates)
    }
}
