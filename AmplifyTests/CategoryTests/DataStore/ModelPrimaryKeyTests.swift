//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest

import AmplifyTestCommon
@testable import Amplify

class ModelPrimaryKeyTests: XCTestCase {
    override func setUp() {

        // default primary keys models
        ModelRegistry.register(modelType: Post.self)

        // custom primary keys models
        ModelRegistry.register(modelType: ModelImplicitDefaultPk.self)
        ModelRegistry.register(modelType: ModelExplicitDefaultPk.self)
        ModelRegistry.register(modelType: ModelExplicitCustomPk.self)

        ModelRegistry.register(modelType: ModelCompositePk.self)

        // custom pk based on indexes
        ModelRegistry.register(modelType: CustomerWithMultipleFieldsinPK.self)

        // custom pk based on primaryKey field
        ModelRegistry.register(modelType: ModelCustomPkDefined.self)
    }

    /// Given: a schema for model with a default primary key defined through the attribute `.primaryKey`
    /// When: a model primary key is built
    /// Then: the only primary key field is found
    func testFindPrimaryKeyDefaultIds() {
        let pk = Post.schema.primaryKey
        XCTAssertEqual(pk.isCompositeKey, false)
        XCTAssertEqual(pk.fields.count, 1)
        XCTAssertEqual(pk.fields[0].name, "id")
    }

    /// Given: a schema for model with an implicit default primary key defined through the attribute `.primaryKey`
    /// When: a model primary key is built
    /// Then: the only primary key field is found
    func testFindPrimaryKeyImplicitIds() {
        let pk = ModelImplicitDefaultPk.schema.primaryKey
        XCTAssertEqual(pk.isCompositeKey, false)
        XCTAssertEqual(pk.fields.count, 1)
        XCTAssertEqual(pk.fields[0].name, "id")
    }

    /// Given: a schema for model with an explicit  primary key field
    ///      defined through the attribute `.primaryKey`
    /// When: a model primary key is built
    /// Then: the only primary key field is found
    func testFindPrimaryKeyExplicitIds() {
        let pk = ModelExplicitDefaultPk.schema.primaryKey
        XCTAssertEqual(pk.isCompositeKey, false)
        XCTAssertEqual(pk.fields.count, 1)
        XCTAssertEqual(pk.fields[0].name, "id")
    }

    /// Given: a schema for model with a custom  primary key field
    ///      defined through the attribute `.primaryKey`
    /// When: a model primary key is built
    /// Then: the custom primary key field is found
    func testFindPrimaryKeyCustomField() {
        let pk = ModelExplicitCustomPk.schema.primaryKey
        XCTAssertEqual(pk.isCompositeKey, false)
        XCTAssertEqual(pk.fields.count, 1)
        XCTAssertEqual(pk.fields[0].name, "userId")
    }

    /// Given: a schema for model with a composite primary key field
    ///      defined through a model  index
    /// When: a model primary key is built
    /// Then: all the primary key fields are found
    func testFindCompositePrimaryKeyFields() {
        let pk = ModelCompositePk.schema.primaryKey
        XCTAssertEqual(pk.isCompositeKey, true)
        XCTAssertEqual(pk.fields.count, 2)
        XCTAssertEqual(pk.fields[0].name, "id")
        XCTAssertEqual(pk.fields[1].name, "dob")
    }

    /// Given: a schema for model with a composite primary key field
    ///      defined through a model  index
    /// When: a model primary key is built
    /// Then: all the primary key fields are found
    func testFindCompositePrimaryKeyMultipleFields() {
        let pk = CustomerWithMultipleFieldsinPK.schema.primaryKey
        let expectedFieldsNames = ["id", "dob", "date", "time", "phoneNumber", "priority", "height"]
        XCTAssertEqual(pk.isCompositeKey, true)
        XCTAssertEqual(pk.fields.count, 7)
        XCTAssertEqual(pk.fields.map { $0.name }, expectedFieldsNames)
    }

    /// Given: a schema for model with a composite primary key field
    ///      defined through the `primaryKey` model pseudo field
    /// When: a model primary key is built
    /// Then: all the primary key fields are found
    func testFindCompositePrimaryKeyPseudoField() {
        let pk = ModelCustomPkDefined.schema.primaryKey
        let expectedFieldsNames = ["id", "dob"]
        XCTAssertEqual(pk.isCompositeKey, true)
        XCTAssertEqual(pk.fields.count, 2)
        XCTAssertEqual(pk.fields.map { $0.name }, expectedFieldsNames)
    }
}
