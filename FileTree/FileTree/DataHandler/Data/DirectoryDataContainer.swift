//
//  DirectoryDataContainer.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 15.06.2022.
//

import Foundation

protocol DirectoryDataContainerDelegate: AnyObject {

  func didUpdataData(items: [DirectoryObject])

}

final class DirectoryDataContainer: NetworkManagerDelegate {

  weak var delegate: DirectoryDataContainerDelegate?
  var collectionData: [DirectoryObject] = []

  func didGetItems(items: [DirectoryObject]) {
    collectionData = items
    delegate?.didUpdataData(items: collectionData)
  }

}
