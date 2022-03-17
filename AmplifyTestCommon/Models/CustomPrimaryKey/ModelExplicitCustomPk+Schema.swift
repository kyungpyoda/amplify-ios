// swiftlint:disable all
import Amplify
import Foundation

extension ModelExplicitCustomPk {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userId
    case name
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let modelExplicitCustomPk = ModelExplicitCustomPk.keys
    
    model.pluralName = "ModelExplicitCustomPks"
    
    model.attributes(
      .index(fields: ["userId"], name: nil)
    )
    
    model.fields(
      .id(),
      .field(modelExplicitCustomPk.userId, is: .required, ofType: .string),
      .field(modelExplicitCustomPk.name, is: .optional, ofType: .string),
      .field(modelExplicitCustomPk.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(modelExplicitCustomPk.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}