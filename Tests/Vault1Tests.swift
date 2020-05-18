// swiftlint:disable force_try
import XCTest
import Vault1
import Crypto

extension Vault1 {
    static func create(password: Password, id: UUID = UUID(), intermediate: Crypto.Symmetric.Key = .init(), master: Bytes) -> (vault: Self, serialized: Data) {
        return Vault1.create(password: password, id: id, intermediate: intermediate, master: master, serializer: ProtobufSerializer.self)
    }
    
    static func open(password: Password, serialized data: Data) throws -> Self {
        return try Vault1.open(password: password, serialized: data, serializer: ProtobufSerializer.self)
    }

    static func open(intermediate: Crypto.Symmetric.Key, serialized data: Data) throws -> Self {
        return try Vault1.open(intermediate: intermediate, serialized: data, serializer: ProtobufSerializer.self)
    }
    
    static func change(old: Password, new: Password, serialized data: Data) throws -> (vault: Self, serialized: Data) {
        return try Vault1.change(old: old, new: new, serialized: data, serializer: ProtobufSerializer.self)
    }

    static func change(intermediate: Crypto.Symmetric.Key, new: Password, serialized data: Data) throws -> (vault: Self, serialized: Data) {
        return try Vault1.change(intermediate: intermediate, new: new, serialized: data, serializer: ProtobufSerializer.self)
    }
}

class VaultTests: XCTestCase {
    func testCreate() {
        let password = "123"
        let id = UUID()
        let intermediate = Crypto.Symmetric.Key()
        let master = Crypto.Symmetric.Key().value
        
        let created = Vault1.create(password: password, id: id, intermediate: intermediate, master: master)
        
        XCTAssert(created.vault.id == id)
        XCTAssert(created.vault.intermediate == intermediate)
        XCTAssert(created.vault.master == master)
    }
    
    func testOpenWithPassword() {
        let password = "123"
        let id = UUID()
        let intermediate = Crypto.Symmetric.Key()
        let master = Crypto.Symmetric.Key().value
        
        let created = Vault1.create(password: password, id: id, intermediate: intermediate, master: master)
        
        let openned = try! Vault1.open(password: password, serialized: created.serialized)
        
        XCTAssert(openned.id == id)
        XCTAssert(openned.intermediate == intermediate)
        XCTAssert(openned.master == master)
    }
    
    func testOpenWithIntermediate() {
        let password = "123"
        let id = UUID()
        let intermediate = Crypto.Symmetric.Key()
        let master = Crypto.Symmetric.Key().value
        
        let created = Vault1.create(password: password, id: id, intermediate: intermediate, master: master)
        
        let openned = try! Vault1.open(intermediate: intermediate, serialized: created.serialized)
        
        XCTAssert(openned.id == id)
        XCTAssert(openned.intermediate == intermediate)
        XCTAssert(openned.master == master)
    }
    
    func testChangeWithPassword() {
        let old = "123"
        let new = "321"
        let id = UUID()
        let intermediate = Crypto.Symmetric.Key()
        let master = Crypto.Symmetric.Key().value
        
        let created = Vault1.create(password: old, id: id, intermediate: intermediate, master: master)
        
        let changed = try! Vault1.change(old: old, new: new, serialized: created.serialized)
        
        // Try to change with Invalid Password
        XCTAssertThrowsError(try Vault1.change(old: "invalid", new: new, serialized: created.serialized)) { error in
            XCTAssertEqual(error as? Crypto.Error, Crypto.Error.couldNotDecrypt)
        }
        
        XCTAssert(changed.vault.id == id)
        XCTAssert(changed.vault.intermediate == intermediate)
        XCTAssert(changed.vault.master == master)
        
        // Open after Change with OLD password
        XCTAssertThrowsError(try Vault1.open(password: old, serialized: changed.serialized)) { error in
            XCTAssertEqual(error as? Crypto.Error, Crypto.Error.couldNotDecrypt)
        }
        
        // Open after Change with NEW password
        XCTAssertNoThrow(try Vault1.open(password: new, serialized: changed.serialized))
    }
    
    func testChangeWithIntermediate() {
        let old = "123"
        let new = "321"
        let id = UUID()
        let intermediate = Crypto.Symmetric.Key()
        let master = Crypto.Symmetric.Key().value
        
        let created = Vault1.create(password: old, id: id, intermediate: intermediate, master: master)
        
        let changed = try! Vault1.change(intermediate: intermediate, new: new, serialized: created.serialized)
        
        // Try to change with Invalid Intermediate
        XCTAssertThrowsError(try Vault1.change(intermediate: Crypto.Symmetric.Key(), new: new, serialized: created.serialized)) { error in
            XCTAssertEqual(error as? Crypto.Error, Crypto.Error.couldNotDecrypt)
        }
        
        XCTAssert(changed.vault.id == id)
        XCTAssert(changed.vault.intermediate == intermediate)
        XCTAssert(changed.vault.master == master)
        
        // Open after Change with OLD password
        XCTAssertThrowsError(try Vault1.open(password: old, serialized: changed.serialized)) { error in
            XCTAssertEqual(error as? Crypto.Error, Crypto.Error.couldNotDecrypt)
        }
        
        // Open after Change with NEW password
        XCTAssertNoThrow(try Vault1.open(password: new, serialized: changed.serialized))
    }
}
