//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

/// AnyModelIdentifierFormat
public protocol AnyModelIdentifierFormat {}

/// Defines the identifier (primary key) format
public enum ModelIdentifierFormat {
    /// Default identifier ("id")
    public enum Default: AnyModelIdentifierFormat {
        public static let name = "id"
    }

    /// Custom or Composite identifier
    public enum Custom: AnyModelIdentifierFormat {
        /// Separator used to derive value of composite key
        public static let separator = "#"

        /// Name for composite identifier (multiple fields)
        public static let name = "@@primaryKey"
    }
}

/// Define requirements for a model to be identifiable with a unique identifier
/// that can be either a single field or a combination of fields
public protocol ModelIdentifiable {
    associatedtype IdentifierFormat: AnyModelIdentifierFormat = ModelIdentifierFormat.Default
    associatedtype Identifier: AnyModelIdentifier
}

public protocol AnyModelIdentifier {
    typealias Field = (name: String, value: Persistable)
    typealias Fields = [Field]

    var fields: AnyModelIdentifier.Fields { get }
    var stringValue: String { get }
    var keys: [String] { get }
    var values: [Persistable] { get }
    var predicate: QueryPredicate { get }
}

public extension AnyModelIdentifier {
    var stringValue: String {
        fields.map { "\($0.value)" }.joined(separator: ModelIdentifierFormat.Custom.separator)
    }

    var keys: [String] {
        fields.map { $0.name }
    }

    var values: [Persistable] {
        fields.map { $0.value }
    }

    var predicate: QueryPredicate {
        // TODO CPK: error handling if identifier is an empty array?
        let firstField = fields[0]
        return fields.reduce(field(firstField.name).eq(firstField.value)) { acc, modelField in
            field(modelField.name).eq(modelField.value) && acc
        }
    }
}

public struct ModelIdentifier<M: Model, F: AnyModelIdentifierFormat>: AnyModelIdentifier {
    public var fields: Fields

    public static func makeDefault(id: String) -> ModelIdentifier<M, ModelIdentifierFormat.Default> {
        ModelIdentifier<M, ModelIdentifierFormat.Default>(fields: [(name: ModelIdentifierFormat.Default.name, value: id)])
    }
}

public extension ModelIdentifier where F == ModelIdentifierFormat.Custom {
    static func make(fields: AnyModelIdentifier.Field...) -> Self {
        Self(fields: fields)
    }
    // Flutter needs this
    static func make(fields: [AnyModelIdentifier.Field]) -> Self {
        Self(fields: fields)
    }
}

public typealias DefaultModelIdentifier<M: Model> = ModelIdentifier<M, ModelIdentifierFormat.Default>

