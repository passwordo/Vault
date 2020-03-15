import Foundation
import Crypto

public enum ProtobufSerializer: Serializer {
    public static func serialize(model: Model) throws -> Data {
        return try Proto.Vault.with {
            $0.id = model.id.data
            $0.version = model.version
            $0.salt = Data(model.salt.value)
            $0.eik = Data(model.encryptedIntermediateKey)
            $0.emk = Data(model.encryptedMasterKey)
        }
        .serializedData()
    }
    
    public static func unserialize(data: Data) throws -> Model {
        let proto = try Proto.Vault(serializedData: data)
        
        return try Model(
            version: proto.version,
            id: UUID(data: proto.id),
            salt: .init(Bytes(proto.salt)),
            encryptedIntermediateKey: Bytes(proto.eik),
            encryptedMasterKey: Bytes(proto.emk)
        )
    }
}
