import Foundation

public protocol Serializer {
    static func serialize(model: Model) throws -> Data
    static func unserialize(data: Data) throws -> Model
}
