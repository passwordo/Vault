import XCTest
import Crypto
@testable import Vault1

class JsonSerializerTests: XCTestCase {
    func testEncodeDecode() {
        let model = Model(version: 1, id: UUID(), salt: .init(), encryptedIntermediateKey: Crypto.Misc.random(256), encryptedMasterKey: Crypto.Misc.random(256))
        
        let serialized = try! JsonSerializer.serialize(model: model)
        let unserialized = try! JsonSerializer.unserialize(data: serialized)
        
        print("serialized -> \(String(data: serialized, encoding: .ascii))")
        
        XCTAssert(model == unserialized)
    }
}
