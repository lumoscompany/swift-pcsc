//
//  Created by Adam Stragner
//

// MARK: - SCardState

public enum SCardState {
    case unknown

    /// There is no card in the reader
    case absent

    /// There is a card in the reader, but it has not been moved into position for use
    case present

    /// There is a card in the reader in position for use. The card is not powered
    case swallowed

    /// Power is being provided to the card, but the reader driver is unaware of the mode of the card
    case powered

    /// The card has been reset and is awaiting PTS negotiation
    case negotiable

    /// The card has been reset and specific communication protocols have been established
    case specific
}

// MARK: Hashable

extension SCardState: Hashable {}

// MARK: Sendable

extension SCardState: Sendable {}

// MARK: - SCardReader.DeviceStatus.CardState + RawRepresentable

public extension SCardState {
    init?(uInt32: UInt32) {
        switch uInt32 {
        case Self.absent.uInt32: self = .absent
        case Self.present.uInt32: self = .present
        case Self.swallowed.uInt32: self = .swallowed
        case Self.powered.uInt32: self = .powered
        case Self.negotiable.uInt32: self = .negotiable
        case Self.specific.uInt32: self = .specific
        default: return nil
        }
    }

    var uInt32: UInt32 {
        switch self {
        case .unknown: 0x0001
        case .absent: 0x0002
        case .present: 0x0004
        case .swallowed: 0x0008
        case .powered: 0x0010
        case .negotiable: 0x0020
        case .specific: 0x0040
        }
    }
}
