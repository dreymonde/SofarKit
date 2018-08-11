import SwiftyTextTable

public struct EventHighlight {
    
    public let code: Int
    public let name: String
    public let status: String
    public let applied: Int
    public let confirmed: Int
    public let canConfirm: Bool
    
    public init(code: Int, name: String, status: String, applied: Int, confirmed: Int, canConfirm: Bool) {
        self.code = code
        self.name = name
        self.status = status
        self.applied = applied
        self.confirmed = confirmed
        self.canConfirm = canConfirm
    }
    
}

extension EventHighlight : TextTableRepresentable {
    
    public static var columnHeaders: [String] {
        return ["code", "Date", "Applied", "Confirmed"]
    }
    
    public var tableValues: [CustomStringConvertible] {
        return [code, name, applied, confirmed]
    }
    
}
