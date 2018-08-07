
public struct SofarEvent {
    
    public let code: Int
    public let name: String
    public let going: Int
    public let vips: Int
    public let expected: Int
    public let venueCap: Int
    public let applied: Int
    public let invited: Int
    public let confirmedNo: Int
    public let notConfirmed: Int
    public let confirmedYes: Int
    public let ticketsSold: Int
    public let checks: [Check]
    
    public init(code: Int, name: String, going: Int, vips: Int, expected: Int, venueCap: Int, applied: Int, invited: Int, confirmedNo: Int, notConfirmed: Int, confirmedYes: Int, ticketsSold: Int, checks: [Check]) {
        self.code = code
        self.name = name
        self.going = going
        self.vips = vips
        self.expected = expected
        self.venueCap = venueCap
        self.applied = applied
        self.invited = invited
        self.confirmedNo = confirmedNo
        self.notConfirmed = notConfirmed
        self.confirmedYes = confirmedYes
        self.ticketsSold = ticketsSold
        self.checks = checks
    }
    
    public struct Check {
        public let text: String
        public let status: Status
        
        public init(text: String, status: Status) {
            self.text = text
            self.status = status
        }
        
        public enum Status {
            case check, times
        }
    }
    
}
