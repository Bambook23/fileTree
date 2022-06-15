//
//  DirectoryObject.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

struct DirectoryObject: Codable {

  let uuid: String
  let parentUUID: String
  let itemType: ItemType
  let itemName: String

  enum CodingKeys: String, CodingKey {
      case uuid = "UUID"
      case parentUUID, itemType, itemName
  }

}

enum ItemType: String, Codable, Comparable {

  case directory = "d"
  case file = "f"

  private var comparisonValue: String {
    switch self {
    case .directory:
      return "directory"
    case .file:
      return "file"
    }
  }

  static func < (lhs: ItemType, rhs: ItemType) -> Bool {
    lhs.comparisonValue < rhs.comparisonValue
  }
  
}
