//
//  Created by Adam Stragner
//

import PCSC
import Essentials

// MARK: - ReaderSession

public final class ReaderSession {
    // MARK: Lifecycle

    public init(with drivers: [PeripheralDeviceDriver.Type] = []) throws (ReaderError) {
        self.drivers = drivers

        do {
            self.hContext = try SCardEstablishContext(.system)
        } catch {
            throw .hardware(error)
        }
    }

    deinit {
        try? SCardReleaseContext(hContext)
    }

    // MARK: Public

    public let drivers: [PeripheralDeviceDriver.Type]

    public func readers(for groups: [SCardReaderGroup]) throws -> [CardReader] {
        try SCardListReaders(hContext, groups).map({
            .init(session: self, name: $0, drivers: drivers)
        })
    }

    // MARK: Internal

    let hContext: SCardContext
}

// MARK: Sendable

extension ReaderSession: Sendable {}
