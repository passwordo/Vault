import XCTest
import Crypto
@testable import Vault1

class ProtobufSerializerTests: XCTestCase {
    func testEncodeDecode() {
        let model = Model(version: 1, id: UUID(), salt: .init(), encryptedIntermediateKey: Crypto.Misc.random(256), encryptedMasterKey: Crypto.Misc.random(256))
        
        let serialized = try! ProtobufSerializer.serialize(model: model)
        let unserialized = try! ProtobufSerializer.unserialize(data: serialized)
        
        XCTAssert(model == unserialized)
    }
}
