import CouchbaseLiteSwift

@propertyWrapper
public struct CBLProperty<T: CBLPropertyProtocol> {
    
    public typealias Validator = (T) -> Bool
    
    private let key: String
    
    private var value: T?
    
    private var defaultValue: T?
    
    private var validator: Validator?
    
    public init(key: String, defaultValue: T? = nil, validator: Validator? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        self.validator = validator
    }
    
    @available(*, unavailable)
    public var wrappedValue: T {
      get { fatalError("Already use enclosing self subscript") }
      set { fatalError("Already use enclosing self subscript") }
    }
    
    public static subscript<EnclosingSelf: CBLPropertyContainer>(
        _enclosingInstance model: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>) -> T {
        get {
            if let storedValue = model[keyPath: storageKeyPath].value {
                return storedValue as T
            }

            let key = model[keyPath: storageKeyPath].key
            let defaultValue = model[keyPath: storageKeyPath].defaultValue
            var value = T.value(from: model.dictionary as MutableDictionaryProtocol,
                                key: key,
                                defaultValue: defaultValue)
            
            // For returning nil for generic type T
            if value == nil {
                let TN = (T.self as! ExpressibleByNilLiteral.Type)
                value = (TN.init(nilLiteral: ()) as! T)
            }
            
            model[keyPath: storageKeyPath].value = value!
            return value!
        }
        set {
            if let validator = model[keyPath: storageKeyPath].validator {
                if !validator(newValue) {
                    return
                }
            }
            
            let key = model[keyPath: storageKeyPath].key
            model.dictionary[key].value = newValue.toCBLValue()
            model[keyPath: storageKeyPath].value = newValue
        }
    }
}
