// swiftlint:disable all
import Amplify
import Foundation

public struct ModelExplicitCustomPk: Model {
  public let id: String
  public var userId: String
  public var name: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userId: String,
      name: String? = nil) {
    self.init(id: id,
      userId: userId,
      name: name,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userId: String,
      name: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userId = userId
      self.name = name
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}