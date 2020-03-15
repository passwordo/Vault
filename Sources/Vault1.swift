import Foundation
import Crypto

/// All properties has `internal` access, as well as `init`
public struct Model: Equatable {
    let version: UInt64
    let id: UUID
    let salt: Crypto.Kdf.Salt
    let encryptedIntermediateKey: Bytes
    let encryptedMasterKey: Bytes
}

public struct Vault1: Equatable {
    public static let VERSION: UInt64 = 1
    
    static let CPU = 20
    static let RAM = 1_024 * 1_024 * 32

    public let id: UUID
    public let intermediate: Crypto.Symmetric.Key
    public let master: Bytes
    
    private init(id: UUID, intermediate: Crypto.Symmetric.Key, master: Bytes) {
        self.id = id
        self.intermediate = intermediate
        self.master = master
    }
    
    // MARK: - Create Vault
    public static func create(password: Password, id: UUID = UUID(), intermediate: Crypto.Symmetric.Key = .init(), master: Bytes, serializer: Serializer.Type = ProtobufSerializer.self) -> (vault: Self, serialized: Data) {
        let salt = Crypto.Kdf.Salt()
        
        let dmp = Crypto.Kdf.derivate(password: password, salt: salt, cpu: Self.CPU, ram: Self.RAM)
        let eik = Crypto.Symmetric.encrypt(data: intermediate.value, key: dmp)
        let emk = Crypto.Symmetric.encrypt(data: master, key: intermediate)
        
        // swiftlint:disable:next force_try
        let serialized = try! serializer.serialize(
            model: Model(
                version: Self.VERSION,
                id: id,
                salt: salt,
                encryptedIntermediateKey: eik,
                encryptedMasterKey: emk
            )
        )
        
        return (vault: .init(id: id, intermediate: intermediate, master: master), serialized: serialized)
    }
    
    // MARK: - Open Vault
    public static func open(password: Password, serialized data: Data, serializer: Serializer.Type = ProtobufSerializer.self) throws -> Self {
        let model = try serializer.unserialize(data: data)

        let dmp = Crypto.Kdf.derivate(password: password, salt: model.salt, cpu: Self.CPU, ram: Self.RAM)
        let intermediate = try Crypto.Symmetric.decrypt(data: model.encryptedIntermediateKey, key: dmp)

        return try self.open(intermediate: .init(intermediate), model: model)
    }

    public static func open(intermediate: Crypto.Symmetric.Key, serialized data: Data, serializer: Serializer.Type = ProtobufSerializer.self) throws -> Self {
        return try self.open(intermediate: intermediate, model: serializer.unserialize(data: data))
    }

    private static func open(intermediate: Crypto.Symmetric.Key, model: Model) throws -> Self {
        let master = try Crypto.Symmetric.decrypt(data: model.encryptedMasterKey, key: intermediate)

        return .init(id: model.id, intermediate: intermediate, master: master)
    }
    
    // MARK: - Change Vault Password
    public static func change(old: Password, new: Password, serialized data: Data, serializer: Serializer.Type = ProtobufSerializer.self) throws -> (vault: Self, serialized: Data) {
        let old = try self.open(password: old, serialized: data, serializer: serializer)

        return self.create(
            password: new,
            id: old.id,
            intermediate: old.intermediate,
            master: old.master,
            serializer: serializer
        )
    }

    public static func change(intermediate: Crypto.Symmetric.Key, new: Password, serialized data: Data, serializer: Serializer.Type = ProtobufSerializer.self) throws -> (vault: Self, serialized: Data) {
        let old = try self.open(intermediate: intermediate, serialized: data, serializer: serializer)

        return self.create(
            password: new,
            id: old.id,
            intermediate: old.intermediate,
            master: old.master,
            serializer: serializer
        )
    }
}
