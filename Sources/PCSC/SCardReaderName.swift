//
//  Created by Adam Stragner
//

// MARK: - SCardReaderName

public struct SCardReaderName: RawRepresentable {
    // MARK: Lifecycle

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    // MARK: Public

    public let rawValue: String
}

// MARK: Hashable

extension SCardReaderName: Hashable {}

// MARK: Sendable

extension SCardReaderName: Sendable {}

// MARK: CustomStringConvertible

extension SCardReaderName: CustomStringConvertible {
    public var description: String {
        "PC/SC Reader: \(rawValue)"
    }
}

extension RangeReplaceableCollection where Element == SCardReaderName {
    init(_ pointer: UnsafeMutablePointer<CChar>?, capacity: Int) {
        self.init([String](pointer, capacity: capacity).map({ .init(rawValue: $0) }))
    }
}
