// swiftlint:disable all
import Amplify
import Foundation

extension ModelCompositePk {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case dob
    case name
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let modelCompositePk = ModelCompositePk.keys
    
    model.pluralName = "ModelCompositePks"
    
    model.attributes(
      .index(fields: ["id", "dob"], name: nil)
    )
    
    model.fields(
        .field(modelCompositePk.id, is: .required, ofType: .string, attributes: [.primaryKey]),
        .field(modelCompositePk.dob, is: .required, ofType: .dateTime, attributes: [.primaryKey]),
        .field(modelCompositePk.name, is: .optional, ofType: .string),
        .field(modelCompositePk.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
        .field(modelCompositePk.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}
