import CouchbaseLiteSwift

@propertyWrapper
public struct CBLProperty<T: CBLPropertyProtocol> {
    private let key: String
    
    private var value: T?
    
    public init(key: String) {
        self.key = key
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
            var value = T.create(from: model.dictionary as MutableDictionaryProtocol, key: key)
            
            // For returning nil for generic type T
            if value == nil {
                let TN = (T.self as! ExpressibleByNilLiteral.Type)
                value = (TN.init(nilLiteral: ()) as! T)
            }
            
            model[keyPath: storageKeyPath].value = value!
            return value!
        }
        set {
            let key = model[keyPath: storageKeyPath].key
            model.dictionary[key].value = newValue.toCBLValue()
            model[keyPath: storageKeyPath].value = newValue
        }
    }
}
