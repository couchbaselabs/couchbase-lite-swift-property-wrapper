import CouchbaseLiteSwift

public typealias MDict = MutableDictionaryProtocol
public typealias MArray = MutableArrayProtocol

public protocol CBLPropertyProtocol {
    static func create(from dict: MDict, key: String) -> Self?
    static func create(from array: MArray, at index: Int) -> Self?
    func toCBLValue() -> Any?
}

extension Int: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Int? { return dict.int(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Int? { return array.int(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Int64: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Int64? { return dict.int64(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Int64? { return array.int64(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Double: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Double? { return dict.double(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Double? { return array.double(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Bool: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Bool? { return dict.boolean(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Bool? { return array.boolean(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension String: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> String? { return dict.string(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> String? { return array.string(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Date: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Date? { return dict.date(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Date? { return array.date(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Blob: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Blob? { return dict.blob(forKey: key) }
    public static func create(from array: MArray, at index: Int) -> Blob? { return array.blob(at: index) }
    public func toCBLValue() -> Any? { return self }
}

extension Array: CBLPropertyProtocol where Element: CBLPropertyProtocol {
    public static func create(from dict: MDict, key: String) -> Array<Element>? {
        if let elements = dict.array(forKey: key) {
            var output: [Element] = []
            for i in 0..<elements.count {
                output.append(Element.create(from: elements, at: i)!)
            }
            return output
        }
        return nil
    }
    
    public static func create(from array: MArray, at index: Int) -> Array<Element>? {
        if let elements = array.array(at: index) {
            var output: [Element] = []
            for i in 0..<elements.count {
                output.append(Element.create(from: elements, at: i)!)
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
    public static func create(from dict: MDict, key: String) -> Self? {
        if dict.contains(key: key) { return Wrapped.create(from: dict, key: key) }
        return nil
    }
    
    public static func create(from array: MArray, at index: Int) -> Self? {
        if array.value(at: index) != nil { return Wrapped.create(from: array, at: index) }
        return nil
    }
    
    public func toCBLValue() -> Any? {
        if let value = self { return value.toCBLValue() }
        return self
    }
}
