//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

// MARK: - Model

/// All persistent models should conform to the Model protocol.
public protocol Model: Codable {
    /// Alias of Model identifier (i.e. primary key)
    @available(*, deprecated, message: "Use ModelIdentifier")
    typealias Identifier = String

    /// A reference to the `ModelSchema` associated with this model.
    static var schema: ModelSchema { get }

    /// The name of the model, as registered in `ModelRegistry`.
    static var modelName: String { get }

    /// Convenience property to return the Type's `modelName`. Developers are strongly encouraged not to override the
    /// instance property, as an implementation that returns a different value for the instance property will cause
    /// undefined behavior.
    var modelName: String { get }

    /// For internal use only when a model schema is provided
    /// (i.e. calls from Flutter)
    func identifier(schema: ModelSchema) -> AnyModelIdentifier
    
    /// Convenience property to access the serialized value of a model identifier
    var identifier: String { get }
}

extension Model {
    public var identifier: String {
        guard let schema = ModelRegistry.modelSchema(from: self.modelName) else {
            fatalError("Schema Not found for \(modelName)")
        }
        return identifier(schema: schema).stringValue
    }
    
    public func identifier(schema: ModelSchema) -> AnyModelIdentifier {
        // Dynamic models don't have fields
        // TODO CPK: how to use this with flutter and dynamic models
        guard !schema.fields.isEmpty else {
            return DefaultModelIdentifier<Self>.makeDefault(fromModel: self)
        }

        let fields: AnyModelIdentifier.Fields = schema.primaryKey.fields.map {
            let value = self[$0.name] as? Persistable ?? ""
            return (name: $0.name, value: value)
        }
        if fields.count == 1, fields[0].name == ModelIdentifierFormat.Default.name {
            return ModelIdentifier<Self, ModelIdentifierFormat.Default>(fields: fields)
        } else {
            return ModelIdentifier<Self, ModelIdentifierFormat.Custom>(fields: fields)
        }
    }
}
