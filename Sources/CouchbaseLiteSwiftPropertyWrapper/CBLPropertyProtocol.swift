import CouchbaseLiteSwift

public typealias MDict = MutableDictionaryProtocol
public typealias MArray = MutableArrayProtocol

public protocol CBLPropertyProtocol {
    static func value(from dict: MDict, key: String, defaultValue: Self?) -> Self?
    static func value(from array: MArray, at index: Int, defaultValue: Self?) -> Self?
    func toCBLValue() -> Any?
}

extension Int: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Int?) -> Int? {
        return dict.value(forKey: key) as? Int ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Int?) -> Int? {
        return array.value(at: index) as? Int ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Int64: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Int64?) -> Int64? {
        return dict.value(forKey: key) as? Int64 ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Int64?) -> Int64? {
        return array.value(at: index) as? Int64 ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Double: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Double?) -> Double? {
        return dict.value(forKey: key) as? Double ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Double?) -> Double? {
        return array.value(at: index) as? Double ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Bool: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Bool?) -> Bool? {
        return dict.value(forKey: key) as? Bool ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Bool?) -> Bool? {
        return array.value(at: index) as? Bool ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension String: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: String?) -> String? {
        return dict.string(forKey: key) ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: String?) -> String? {
        return array.string(at: index) ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Date: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Date?) -> Date? {
        return dict.date(forKey: key) ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Date?) -> Date? {
        return array.date(at: index) ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Blob: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Blob?) -> Blob? {
        return dict.blob(forKey: key) ?? defaultValue
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Blob?) -> Blob? {
        return array.blob(at: index) ?? defaultValue
    }
    
    public func toCBLValue() -> Any? {
        return self
    }
}

extension Array: CBLPropertyProtocol where Element: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Array<Element>?) -> Array<Element>? {
        if let elements = dict.array(forKey: key) {
            var output: [Element] = []
            for i in 0..<elements.count {
                output.append(Element.value(from: elements, at: i, defaultValue: nil)!)
            }
            return output
        }
        return nil
    }

    public static func value(from array: MArray, at index: Int, defaultValue: Array<Element>?) -> Array<Element>? {
        if let elements = array.array(at: index) {
            var output: [Element] = []
            for i in 0..<elements.count {
                output.append(Element.value(from: elements, at: i, defaultValue: nil)!)
            }
            return output
        }
        return nil
    }
    
    public func toCBLValue() -> Any? {
        return MutableArrayObject.init(data: self.map { $0.toCBLValue()! })
    }
}

extension Optional: CBLPropertyProtocol where Wrapped: CBLPropertyProtocol {
    public static func value(from dict: MDict, key: String, defaultValue: Self?) -> Self? {
        return Wrapped.value(from: dict, key: key, defaultValue: defaultValue as? Wrapped)
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Self?) -> Self? {
        if array.value(at: index) != nil {
            return Wrapped.value(from: array, at: index, defaultValue: defaultValue as? Wrapped)
        }
        return defaultValue
    }
    
    public func toCBLValue() -> Any? {
        if let value = self {
            return value.toCBLValue()
        }
        return self
    }
}
