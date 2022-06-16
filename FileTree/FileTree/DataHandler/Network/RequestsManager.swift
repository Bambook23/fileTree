//
//  RequestsManager.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {

  func didGetItems(items: [DirectoryObject])

}

protocol NetworkManager {

  var delegate: NetworkManagerDelegate? {get set}
  func getItems()
  func deleteItems(uuid: String, itemType: ItemType)
  func createItem(parentUUID: String, itemType: ItemType, itemName: String)

}

final class RequestsManager: NetworkManager {

  weak var delegate: NetworkManagerDelegate?

  let networkService = APINetworkService()

  func getItems() {
    let request = Request(method: .get, url: "https://sheetdb.io/api/v1/ijtc8qex0zds3")
    networkService.sendRequest(request: request, dataType: [DirectoryObject].self) { result in
      switch result {
      case .success(let items):
        DispatchQueue.main.async {
          self.delegate?.didGetItems(items: items)
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  func deleteItems(uuid: String, itemType: ItemType) {
    if itemType == .directory {
      let childrenDeleteRequest = Request(method: .delete,
                                          url: "https://sheetdb.io/api/v1/ijtc8qex0zds3/parentUUID/\(uuid)")
      networkService.sendRequest(request: childrenDeleteRequest, dataType: [String : Int].self) { result in
        switch result {
        case .success(let result):
          print(result)
        case .failure(let error):
          print(error)
        }
      }
    }

    let itemDeleteRequest = Request(method: .delete,
                          url: "https://sheetdb.io/api/v1/ijtc8qex0zds3/UUID/\(uuid)")
    networkService.sendRequest(request: itemDeleteRequest, dataType: [String : Int].self) { result in
      switch result {
      case .success(let result):
        print(result)
        self.getItems()
      case .failure(let error):
        print(error)
      }
    }
  }

  func createItem(parentUUID: String, itemType: ItemType, itemName: String) {
    let param: [String: Any] = ["data": [["UUID": "\(UUID().uuidString)",
                                          "parentUUID": "DB5CBFD0-8A96-4D1E-B2A7-09419BDC2198",
                                          "itemType": itemType.rawValue,
                                          "itemName": itemName]]]
    
    let request = Request(method: .post,
                          url: "https://sheetdb.io/api/v1/ijtc8qex0zds3",
                          headers: ["Content-Type": "application/json"],
                          body: param)

    networkService.sendRequest(request: request,
                               dataType: [String: Int].self) { result in
      switch result {
      case .success(let result):
        print(result)
      case .failure(let error):
        print(error)
      }
    }
  }

}
