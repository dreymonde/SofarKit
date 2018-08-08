import Rainbow

struct SofarKit {
    var text = "Hello, World!"
}

public enum SofarKitError : Error {
    case invalidHTML
    case notANumber(String)
    case invalidCookie
}

extension Optional {
    
    public func requiredIfValidHTML() throws -> Wrapped {
        return try required(orThrow: SofarKitError.invalidHTML)
    }
    
}

extension String {
    
    public func requiredNumber() throws -> Int {
        if let number = Int(self) {
            return number
        } else {
            throw SofarKitError.notANumber(self)
        }
    }
    
}

extension Optional {
    
    public func required(orThrow error: Error) throws -> Wrapped {
        if let value = self {
            return value
        }
        throw error
    }
    
}

