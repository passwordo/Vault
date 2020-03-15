import Foundation

public enum JsonSerializer: Serializer {
    public static func serialize(model: Model) throws -> Data {
        return try JSONEncoder().encode(model)
    }
    
    public static func unserialize(data: Data) throws -> Model {
        return try JSONDecoder().decode(Model.self, from: data)
    }
}

extension Model: Encodable, Decodable {
    enum CodingKeys: String, CodingKey {
        case version
        case id
        case salt
        case eik
        case emk
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.version, forKey: .version)
        try container.encode(self.id.data, forKey: .id)
        try container.encode(self.salt.value, forKey: .salt)
        try container.encode(self.encryptedIntermediateKey, forKey: .eik)
        try container.encode(self.encryptedMasterKey, forKey: .emk)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version = try container.decode(UInt64.self, forKey: .version)
        self.id = try .init(data: container.decode(Data.self, forKey: .id))
        self.salt = try .init(container.decode([UInt8].self, forKey: .salt))
        self.encryptedIntermediateKey = try container.decode([UInt8].self, forKey: .eik)
        self.encryptedMasterKey = try container.decode([UInt8].self, forKey: .emk)
    }
}
