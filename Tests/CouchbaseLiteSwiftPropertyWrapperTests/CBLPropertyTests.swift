import XCTest
import CouchbaseLiteSwift
@testable import CouchbaseLiteSwiftPropertyWrapper

final class CBLPropertyTests: XCTestCase {
    var db: Database!
    
    override func setUpWithError() throws {
        try Database.delete(withName: "db")
        db = try Database.init(name: "db")
    }
    
    override func tearDownWithError() throws {
        try db.delete()
    }
    
    class BaseModel: CBLPropertyContainer {
        var dictionary: MutableDictionaryProtocol
        required init(with dictionary: MutableDictionaryProtocol) { self.dictionary = dictionary }
    }
    
    func dateFromJson(_ date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.timeZone = NSTimeZone.local
        return formatter.date(from: date)!
    }
    
    func testBasicTypes() throws {
        class Model: BaseModel {
            @CBLProperty(key: "p_int")
            var p_int: Int
            
            @CBLProperty(key: "p_int64")
            var p_int64: Int64
            
            @CBLProperty(key: "p_double")
            var p_double: Double
            
            @CBLProperty(key: "p_bool")
            var p_bool: Bool
            
            @CBLProperty(key: "p_string")
            var p_string: String
            
            @CBLProperty(key: "p_date")
            var p_date: Date
            
            @CBLProperty(key: "p_blob")
            var p_blob: Blob
        }
        
        let date1 = dateFromJson("2020-01-01T00:00:00.000Z")
        let date2 = dateFromJson("2020-06-06T00:00:00.000Z")
        let blob1 = Blob(contentType: "text/plain", data: "I'm BoB".data(using: .utf8)!)
        let blob2 = Blob(contentType: "text/plain", data: "I'm PoP".data(using: .utf8)!)
        
        let dict1 = MutableDictionaryObject()
        dict1.setInt(10, forKey: "p_int")
        dict1.setInt64(100, forKey: "p_int64")
        dict1.setDouble(99.99, forKey: "p_double")
        dict1.setBoolean(true, forKey: "p_bool")
        dict1.setString("hello", forKey: "p_string")
        dict1.setDate(date1, forKey: "p_date")
        dict1.setBlob(blob1, forKey: "p_blob")
        
        let model1 = Model(with: dict1)
        XCTAssertEqual(model1.p_int, dict1.int(forKey: "p_int"))
        XCTAssertEqual(model1.p_int64, dict1.int64(forKey: "p_int64"))
        XCTAssertEqual(model1.p_double, dict1.double(forKey: "p_double"))
        XCTAssertEqual(model1.p_bool, dict1.boolean(forKey: "p_bool"))
        XCTAssertEqual(model1.p_string, dict1.string(forKey: "p_string"))
        XCTAssertEqual(model1.p_date, dict1.date(forKey: "p_date"))
        XCTAssertEqual(model1.p_blob, dict1.blob(forKey: "p_blob"))
        
        model1.p_int = 20
        model1.p_int64 = 200
        model1.p_double = 999.99
        model1.p_bool = false
        model1.p_string = "hello world!"
        model1.p_date = date2
        model1.p_blob = blob2
        
        XCTAssertEqual(model1.p_int, Int(20))
        XCTAssertEqual(model1.p_int64, Int64(200))
        XCTAssertEqual(model1.p_double, Double(999.99))
        XCTAssertEqual(model1.p_bool, false)
        XCTAssertEqual(model1.p_string, "hello world!")
        XCTAssertEqual(model1.p_date, date2)
        XCTAssertEqual(model1.p_blob, blob2)
        
        XCTAssertEqual(dict1.int(forKey: "p_int"), Int(20))
        XCTAssertEqual(dict1.int64(forKey: "p_int64"), Int64(200))
        XCTAssertEqual(dict1.double(forKey: "p_double"), Double(999.99))
        XCTAssertEqual(dict1.boolean(forKey: "p_bool"), false)
        XCTAssertEqual(dict1.string(forKey: "p_string"), "hello world!")
        XCTAssertEqual(dict1.date(forKey: "p_date"), date2)
        XCTAssertEqual(dict1.blob(forKey: "p_blob"), blob2)
    }
    
    func testBasicOptionalTypes() throws {
        class Model: BaseModel {
            @CBLProperty(key: "p_int_opt")
            var p_int_opt: Int?
            
            @CBLProperty(key: "p_int64_opt")
            var p_int64_opt: Int64?
            
            @CBLProperty(key: "p_double_opt")
            var p_double_opt: Double?
            
            @CBLProperty(key: "p_bool_opt")
            var p_bool_opt: Bool?
            
            @CBLProperty(key: "p_string_opt")
            var p_string_opt: String?
            
            @CBLProperty(key: "p_date_opt")
            var p_date_opt: Date?
            
            @CBLProperty(key: "p_blob_opt")
            var p_blob_opt: Blob?
        }
        
        let date1 = dateFromJson("2020-01-01T00:00:00.000Z")
        let blob1 = Blob(contentType: "text/plain", data: "I'm BoB".data(using: .utf8)!)
        
        let dict1 = MutableDictionaryObject()
        let model1 = Model(with: dict1)
        
        XCTAssertNil(model1.p_int_opt)
        XCTAssertNil(model1.p_int64_opt)
        XCTAssertNil(model1.p_double_opt)
        XCTAssertNil(model1.p_bool_opt)
        XCTAssertNil(model1.p_string_opt)
        XCTAssertNil(model1.p_date_opt)
        XCTAssertNil(model1.p_blob_opt)
        
        model1.p_int_opt = 30
        model1.p_int64_opt = 300
        model1.p_double_opt = 99.98
        model1.p_bool_opt = true
        model1.p_string_opt = "hi!"
        model1.p_date_opt = date1
        model1.p_blob_opt = blob1
        
        XCTAssertEqual(model1.p_int_opt, Int(30))
        XCTAssertEqual(model1.p_int64_opt, Int64(300))
        XCTAssertEqual(model1.p_double_opt, Double(99.98))
        XCTAssertEqual(model1.p_bool_opt, true)
        XCTAssertEqual(model1.p_string_opt, "hi!")
        XCTAssertEqual(model1.p_date_opt, date1)
        XCTAssertEqual(model1.p_blob_opt, blob1)
        
        XCTAssertEqual(dict1.int(forKey: "p_int_opt"), Int(30))
        XCTAssertEqual(dict1.int64(forKey: "p_int64_opt"), Int64(300))
        XCTAssertEqual(dict1.double(forKey: "p_double_opt"), Double(99.98))
        XCTAssertEqual(dict1.boolean(forKey: "p_double_opt"), true)
        XCTAssertEqual(dict1.string(forKey: "p_string_opt"), "hi!")
        XCTAssertEqual(dict1.date(forKey: "p_date_opt"), date1)
        XCTAssertEqual(dict1.blob(forKey: "p_blob_opt"), blob1)
    }
    
    func testArray() {
        class Model: BaseModel {
            @CBLProperty(key: "p_array_int")
            var p_array_int: [Int]
            
            @CBLProperty(key: "p_array_int64")
            var p_array_int64: [Int64]
            
            @CBLProperty(key: "p_array_double")
            var p_array_double: [Double]
            
            @CBLProperty(key: "p_array_bool")
            var p_array_bool: [Bool]
            
            @CBLProperty(key: "p_array_string")
            var p_array_string: [String]
        }
        
        let dict1 = MutableDictionaryObject()
        dict1.setValue([1, 2, 3], forKey: "p_array_int")
        dict1.setValue([5, 6, 7] as [Int64], forKey: "p_array_int64")
        dict1.setValue([1.1, 1.2, 1.3], forKey: "p_array_double")
        dict1.setValue([true, false, true], forKey: "p_array_bool")
        dict1.setValue(["1", "2", "3"], forKey: "p_array_string")
        
        let model1 = Model(with: dict1)
        XCTAssertEqual(model1.p_array_int, [1, 2, 3])
        XCTAssertEqual(model1.p_array_int64, [5, 6, 7] as [Int64])
        XCTAssertEqual(model1.p_array_double, [1.1, 1.2, 1.3])
        XCTAssertEqual(model1.p_array_bool, [true, false, true])
        XCTAssertEqual(model1.p_array_string, ["1", "2", "3"])
        
        model1.p_array_int = [2, 4, 8]
        model1.p_array_int64 = [10, 100, 1000]
        model1.p_array_double = [2.0, 2.5, 3.0]
        model1.p_array_bool = [false, true, false]
        model1.p_array_string = ["a", "b", "c"]
        
        XCTAssertEqual(model1.p_array_int, [2, 4, 8])
        XCTAssertEqual(model1.p_array_int64, [10, 100, 1000] as [Int64])
        XCTAssertEqual(model1.p_array_double, [2.0, 2.5, 3.0])
        XCTAssertEqual(model1.p_array_bool, [false, true, false])
        XCTAssertEqual(model1.p_array_string, ["a", "b", "c"])
        
        XCTAssertEqual(dict1.array(forKey: "p_array_int")!.toArray() as! [Int], [2, 4, 8])
        XCTAssertEqual(dict1.array(forKey: "p_array_int64")!.toArray() as! [Int64], [10, 100, 1000])
        XCTAssertEqual(dict1.array(forKey: "p_array_double")!.toArray() as! [Double], [2.0, 2.5, 3.0])
        XCTAssertEqual(dict1.array(forKey: "p_array_bool")!.toArray() as! [Bool], [false, true, false])
        XCTAssertEqual(dict1.array(forKey: "p_array_string")!.toArray() as! [String], ["a", "b", "c"])
    }
    
    func testOptionalArray() {
        class Model: BaseModel {
            @CBLProperty(key: "p_array_int_opt")
            var p_array_int_opt: [Int]?
            
            @CBLProperty(key: "p_array_int64_opt")
            var p_array_int64_opt: [Int64]?
            
            @CBLProperty(key: "p_array_double_opt")
            var p_array_double_opt: [Double]?
            
            @CBLProperty(key: "p_array_bool_opt")
            var p_array_bool_opt: [Bool]?
            
            @CBLProperty(key: "p_array_string_opt")
            var p_array_string_opt: [String]?
        }
        
        let dict1 = MutableDictionaryObject()
        let model1 = Model(with: dict1)
        
        model1.p_array_int_opt = [1, 2, 3]
        model1.p_array_int64_opt = [5, 6, 7]
        model1.p_array_double_opt = [1.1, 1.2, 1.3]
        model1.p_array_bool_opt = [true, false, true]
        model1.p_array_string_opt = ["1", "2", "3"]
        
        XCTAssertEqual(model1.p_array_int_opt, [1, 2, 3])
        XCTAssertEqual(model1.p_array_int64_opt, [5, 6, 7] as [Int64])
        XCTAssertEqual(model1.p_array_double_opt, [1.1, 1.2, 1.3])
        XCTAssertEqual(model1.p_array_bool_opt, [true, false, true])
        XCTAssertEqual(model1.p_array_string_opt, ["1", "2", "3"])
        
        XCTAssertEqual(dict1.array(forKey: "p_array_int_opt")!.toArray() as! [Int], [1, 2, 3])
        XCTAssertEqual(dict1.array(forKey: "p_array_int64_opt")!.toArray() as! [Int64], [5, 6, 7])
        XCTAssertEqual(dict1.array(forKey: "p_array_double_opt")!.toArray() as! [Double], [1.1, 1.2, 1.3])
        XCTAssertEqual(dict1.array(forKey: "p_array_bool_opt")!.toArray() as! [Bool], [true, false, true])
        XCTAssertEqual(dict1.array(forKey: "p_array_string_opt")!.toArray() as! [String], ["1", "2", "3"])
    }
    
    func testObject() {
        class Model: BaseModel {
            @CBLProperty(key: "p_object")
            var p_object: AnotherModel
            
            @CBLProperty(key: "p_array_object")
            var p_array_object: [AnotherModel]
        }
        
        class AnotherModel: BaseModel {
            @CBLProperty(key: "p_string")
            var p_string: String
        }
        
        let dict1 = MutableDictionaryObject()
        dict1.setData([
            "p_object": ["p_string": "A"],
            "p_array_object": [["p_string": "1"]]
        ])
        
        // Update object's value
        let model1 = Model(with: dict1)
        XCTAssertEqual(model1.p_object.p_string, "A")
        XCTAssertEqual(model1.p_array_object.count, 1)
        XCTAssertEqual(model1.p_array_object[0].p_string, "1")
        
        model1.p_object.p_string = "B"
        let obj = AnotherModel(with: MutableDictionaryObject())
        obj.p_string = "2"
        model1.p_array_object.append(obj)
        
        XCTAssertEqual(model1.p_object.p_string, "B")
        XCTAssertEqual(model1.p_array_object.count, 2)
        XCTAssertEqual(model1.p_array_object[1].p_string, "2")
        XCTAssertTrue(dict1.toDictionary() == [
            "p_object": ["p_string": "B"],
            "p_array_object": [["p_string": "1"], ["p_string": "2"]]
        ])
        
        // Update with a new object
        let newObj1 = AnotherModel(with: MutableDictionaryObject())
        newObj1.p_string = "C"
        model1.p_object = newObj1
        
        let newObj2 = AnotherModel(with: MutableDictionaryObject())
        newObj2.p_string = "X"
        model1.p_array_object = [newObj2]
        
        XCTAssertEqual(model1.p_object.p_string, "C")
        XCTAssertEqual(model1.p_array_object.count, 1)
        XCTAssertEqual(model1.p_array_object[0].p_string, "X")
        XCTAssertTrue(dict1.toDictionary() == [
            "p_object": ["p_string": "C"],
            "p_array_object": [["p_string": "X"]]
        ])
    }
    
    func testOptionalObject() {
        class Model: BaseModel {
            @CBLProperty(key: "p_object")
            var p_object: AnotherModel?
            
            @CBLProperty(key: "p_array_object")
            var p_array_object: [AnotherModel]?
        }
        
        class AnotherModel: BaseModel {
            @CBLProperty(key: "p_string")
            var p_string: String?
        }
        
        let dict1 = MutableDictionaryObject()
        let model1 = Model(with: dict1)
        
        XCTAssertNil(model1.p_object)
        XCTAssertNil(model1.p_array_object)
        
        let newObj1 = AnotherModel(with: MutableDictionaryObject())
        newObj1.p_string = "C"
        model1.p_object = newObj1
        
        let newObj2 = AnotherModel(with: MutableDictionaryObject())
        newObj2.p_string = "X"
        model1.p_array_object = [newObj2]
        
        XCTAssertEqual(model1.p_object?.p_string, "C")
        XCTAssertEqual(model1.p_array_object?.count, 1)
        XCTAssertEqual(model1.p_array_object?[0].p_string, "X")
        XCTAssertTrue(dict1.toDictionary() == [
            "p_object": ["p_string": "C"],
            "p_array_object": [["p_string": "X"]]
        ])
    }
    
    func testDefaultValue() throws {
        class Model: BaseModel {
            @CBLProperty(key: "value1", defaultValue: 10)
            var value1: Int?
            
            @CBLProperty(key: "value2", defaultValue: 20)
            var value2: Int
            
            @CBLProperty(key: "value3")
            var value3: Int?
        }
        
        let dict1 = MutableDictionaryObject()
        let model = Model(with: dict1)
        
        XCTAssertEqual(model.value1, 10)
        XCTAssertEqual(model.value2, 20)
        XCTAssertNil(model.value3)
        
        XCTAssertNil(dict1.value(forKey: "value1"))
        XCTAssertNil(dict1.value(forKey: "value2"))
        XCTAssertNil(dict1.value(forKey: "value3"))
        
        model.value1 = 100
        model.value2 = 200
        model.value3 = 300
        
        XCTAssertEqual(model.value1, 100)
        XCTAssertEqual(model.value2, 200)
        XCTAssertEqual(model.value3, 300)
        
        XCTAssertEqual(dict1.int(forKey: "value1"), 100)
        XCTAssertEqual(dict1.int(forKey: "value2"), 200)
        XCTAssertEqual(dict1.int(forKey: "value3"), 300)
    }
    
    func testValidator() throws {
        class Model: BaseModel {
            @CBLProperty(key: "value", validator: {(v) -> Bool in v ?? 0 > 10} )
            var value: Int?
        }
        
        let dict1 = MutableDictionaryObject()
        let model = Model(with: dict1)
        
        model.value = 5
        XCTAssertNil(model.value)
        
        model.value = 11
        XCTAssertEqual(model.value, 11)
    }
}

public func ==(lhs: [String: Any], rhs: [String: Any] ) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
