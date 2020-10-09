import XCTest
import CouchbaseLiteSwift
@testable import CouchbaseLiteSwiftPropertyWrapper

final class CBLModelTests: XCTestCase {
    var db: Database!
    
    override func setUpWithError() throws {
        try Database.delete(withName: "db")
        db = try Database.init(name: "db")
    }
    
    override func tearDownWithError() throws {
        try db.delete()
    }
    
    func testInit() throws {
        let person = Person()
        XCTAssertNil(person.document)
        XCTAssertNotNil(person.dictionary)
        
        XCTAssertNil(person.name)
        XCTAssertNil(person.address)
        XCTAssertNil(person.contacts)
        
        person.name = "Daniel"
        person.address = Address()
        person.address?.street = "1 Main Street"
        person.contacts = [Person()]
        person.contacts![0].name = "James"
        
        XCTAssertEqual(person.name, "Daniel")
        XCTAssertEqual(person.address?.street, "1 Main Street")
        XCTAssertEqual(person.contacts?.count, 1)
        XCTAssertEqual(person.contacts?[0].name, "James")
        
        XCTAssertTrue(person.dictionary.toDictionary() == [
            "name": "Daniel",
            "address": ["street": "1 Main Street"],
            "contacts": [["name": "James"]]
        ])
    }
    
    func testInitWithDict() throws {
        let dict = MutableDictionaryObject()
        let person = Person(with: dict)
        XCTAssertNil(person.document)
        XCTAssertNotNil(person.dictionary)
        XCTAssertTrue(person.dictionary as! MutableDictionaryObject === dict)
        
        XCTAssertNil(person.name)
        XCTAssertNil(person.address)
        XCTAssertNil(person.contacts)
        
        person.name = "Daniel"
        person.address = Address()
        person.address?.street = "1 Main Street"
        person.contacts = [Person()]
        person.contacts![0].name = "James"
        
        XCTAssertEqual(person.name, "Daniel")
        XCTAssertEqual(person.address?.street, "1 Main Street")
        XCTAssertEqual(person.contacts?.count, 1)
        XCTAssertEqual(person.contacts?[0].name, "James")
        XCTAssertTrue(person.dictionary.toDictionary() == [
            "name": "Daniel",
            "address": ["street": "1 Main Street"],
            "contacts": [["name": "James"]]
        ])
    }
    
    func testInitWithDocument() throws {
        let mdoc = MutableDocument(id: "doc1")
        let person = Person(with: mdoc)
        XCTAssertNotNil(person.dictionary)
        XCTAssertNotNil(person.document)
        XCTAssertTrue(person.document! === mdoc)
        XCTAssertTrue(person.dictionary as! MutableDocument === person.document!)
        
        XCTAssertNil(person.name)
        XCTAssertNil(person.address)
        XCTAssertNil(person.contacts)
        
        person.name = "Daniel"
        person.address = Address()
        person.address?.street = "1 Main Street"
        person.contacts = [Person()]
        person.contacts![0].name = "James"
        
        XCTAssertEqual(person.name, "Daniel")
        XCTAssertEqual(person.address?.street, "1 Main Street")
        XCTAssertEqual(person.contacts?.count, 1)
        XCTAssertEqual(person.contacts?[0].name, "James")
        XCTAssertTrue(person.dictionary.toDictionary() == [
            "name": "Daniel",
            "address": ["street": "1 Main Street"],
            "contacts": [["name": "James"]]
        ])
        
        // Save
        try person.save(into: self.db)
        
        let doc = db.document(withID: person.document!.id)
        XCTAssertNotNil(doc)
        XCTAssertTrue(doc!.toDictionary() == [
            "name": "Daniel",
            "address": ["street": "1 Main Street"],
            "contacts": [["name": "James"]]
        ])
    }
    
    class Person: CBLModel {
        @CBLProperty(key: "name")
        var name: String?
        
        @CBLProperty(key: "address")
        var address: Address?
        
        @CBLProperty(key: "contacts")
        var contacts: [Person]?
    }

    class Address: CBLModel {
        @CBLProperty(key: "street")
        var street: String?
    }
}
