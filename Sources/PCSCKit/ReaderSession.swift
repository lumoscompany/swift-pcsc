//
//  Created by Adam Stragner
//

import PCSC
import Essentials
import Logging

// MARK: - ReaderSession

public final class ReaderSession {
    // MARK: Lifecycle

    public init() throws (ReaderError) {
        let logger = Logger(label: "ReaderSession")
        do {
            self.hContext = try SCardEstablishContext(.system)
            logger.info("Context successfully established")
        } catch {
            logger.error("Context establishing error: \(error.localizedDescription)")
            throw .hardware(error)
        }
        self.logger = logger
    }

    deinit {
        try? SCardReleaseContext(hContext)
    }

    // MARK: Public

    public func readers(
        for groups: [SCardReaderGroup] = [],
        compatibleWith drivers: [PeripheralDeviceDriver.Type] = []
    ) throws -> [CardReader] {
        let readers = try SCardListReaders(hContext, groups).map({
            CardReader(session: self, name: $0, drivers: drivers)
        })

        guard !drivers.isEmpty
        else {
            return readers
        }

        return readers.filter({ reader in
            drivers.contains(where: { $0 == reader.driver })
        })
    }

    // MARK: Internal

    let hContext: SCardContext

    // MARK: Private

    private let logger: Logger
}

// MARK: Sendable

extension ReaderSession: Sendable {}
