import CouchbaseLiteSwift

public protocol CBLPropertyContainer: CBLPropertyProtocol {
    var dictionary: MutableDictionaryProtocol { get }
    init(with dictionary: MutableDictionaryProtocol)
}

extension CBLPropertyContainer {
    public static func value(from dict: MDict, key: String, defaultValue: Self?) -> Self? {
        if let dict = dict.dictionary(forKey: key) { return self.init(with: dict) }
        return nil
    }
    
    public static func value(from array: MArray, at index: Int, defaultValue: Self?) -> Self? {
        if let dict = array.dictionary(at: index) { return self.init(with: dict) }
        return nil
    }
    
    public func toCBLValue() -> Any? {
        return self.dictionary
    }
}

class CBLModel: CBLPropertyContainer {
    let dictionary: MutableDictionaryProtocol
    
    let document: MutableDocument?
    
    required init(with dictionary: MutableDictionaryProtocol) {
        self.dictionary = dictionary
        if let doc = dictionary as? MutableDocument {
            self.document = doc
        } else {
            self.document = nil
        }
    }
    
    convenience init(with document: MutableDocument) {
        self.init(with: document as MutableDictionaryProtocol)
    }
    
    convenience init(with document: Document) {
        self.init(with: document.toMutable() as MutableDictionaryProtocol)
    }
    
    convenience init() {
        self.init(with: MutableDictionaryObject() as MutableDictionaryProtocol)
    }
    
    @discardableResult
    func save(into database: Database, concurrencyControl: ConcurrencyControl = .lastWriteWins) throws -> Bool {
        guard let doc = self.document else {
            fatalError("The model cannot be saved as it doesn't contain a document")
        }
        return try database.saveDocument(doc, concurrencyControl: concurrencyControl)
    }
}
