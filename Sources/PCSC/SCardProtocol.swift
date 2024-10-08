//
//  Created by Adam Stragner
//

import Essentials
@_implementationOnly import Clibpcsclite

// MARK: - SCardProtocol

/// - warning: `.raw` is no longer available for `pcsc-lite` & `Winscard`
public enum SCardProtocol {
    case undefined

    /// Equals `undefined`; backward compatibility
    case unset

    /// T=0 protocol
    case t0

    /// T=1 protocol
    case t1

    /// For memory cards
    case raw

    // case t15
}

// MARK: Hashable

extension SCardProtocol: Hashable {}

// MARK: Sendable

extension SCardProtocol: Sendable {}

extension SCardProtocol {
    init?(uInt32: UInt32) {
        switch uInt32 {
        case Self.undefined.uInt32: self = .undefined
        case Self.t0.uInt32: self = .t0
        case Self.t1.uInt32: self = .t1
        case Self.raw.uInt32: self = .raw
        // case Self.t15.uInt32: self = .t15
        default: return nil
        }
    }

    static func required(with uInt32: UInt32) throws (SCardError) -> Self {
        switch uInt32 {
        case undefined.uInt32, unset.uInt32: .undefined
        case t0.uInt32: .t0
        case t1.uInt32: .t1
        case raw.uInt32: .raw
        default: throw .init(.protoMismatch)
        }
    }

    var uInt32: UInt32 {
        switch self {
        case .undefined, .unset: UInt32(CSCARD_PROTOCOL_UNDEFINED)
        case .t0: UInt32(CSCARD_PROTOCOL_T0)
        case .t1: UInt32(CSCARD_PROTOCOL_T1)
        case .raw: UInt32(CSCARD_PROTOCOL_RAW)
        }
    }
}

extension Sequence where Element == SCardProtocol {
    var uInt32: UInt32 {
        reduce(into: UInt32(0), { $0 |= $1.uInt32 })
    }
}
