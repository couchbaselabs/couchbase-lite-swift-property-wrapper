# CouchbaseLiteSwiftPropertyWrapper

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

An experiment using Swift's Propery Wrappers to build data model for Couchbase Lite Swift.

## Limitation
* The library is using EnclosingSelf feature which is still in proposal/experimental state.
* As the `EnclosingSelf feature is used, only Class (not Struct) can use the property wrapper.

## Requirements
* CouchbaseLiteSwift 2.8+ (NOT RELEASED YET)

## Platforms
* iOS (9.0+) and macOS (10.11+)
* XCode 12+

## Example

### Model

```Swift
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
```

### Usage

```Swift
let person = Person(with: MutableDocument())
person.name = "Daniel"

let address = Address()
address.street = "1 Main st."
person.address = address

let contact = Person()
contact.name = "James"
person.contacts = [contact]

try person.save(into: self.database)
```

### Document data
```Swift
[ "name": "Daniel"
  "address": ["street": "1 Main st."]
  "contacts": [
  	["name": "James]
  ]
]

```
