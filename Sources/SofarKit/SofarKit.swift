import Rainbow

struct SofarKit {
    var text = "Hello, World!"
}

extension Optional {
    
    public func requiredIfValidHTML() -> Wrapped {
        return required(because: "Invalid HTML".red)
    }
    
}

extension String {
    
    public func requiredNumber() -> Int {
        if let number = Int(self) {
            return number
        } else {
            preconditionFailure("Should be number, got \(self) instead".red)
        }
    }
    
}

extension Optional {
    
    public func required(because: String) -> Wrapped {
        if let value = self {
            return value
        }
        preconditionFailure(because)
    }
    
}

