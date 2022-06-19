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
  func createItem(parentUUID: String, itemType: ItemType, itemName: String, completion: @escaping (() -> Void?))

}

// table url: https://docs.google.com/spreadsheets/d/1zWXytT6zQE4LIp2WV2Gt1ZYzk7A98JLjsEvOuQDGkfM/edit?usp=sharing

final class RequestsManager: NetworkManager {

  weak var delegate: NetworkManagerDelegate?

  let networkService = APINetworkService()

  func getItems() {
    let request = Request(method: .get, url: "https://sheetdb.io/api/v1/s7dqserrq6y3s")
    networkService.sendRequest(request: request, dataType: [DirectoryObject].self) { [weak self] result in
      switch result {
      case .success(let items):
        DispatchQueue.main.async {
          self?.delegate?.didGetItems(items: items)
        }
      case .failure(let error):
        print(error)
      }
    }
  }

  func deleteItems(uuid: String, itemType: ItemType) {
    let itemDeleteRequest = Request(method: .delete,
                                    url: "https://sheetdb.io/api/v1/s7dqserrq6y3s/UUID/\(uuid)")
    networkService.sendRequest(request: itemDeleteRequest, dataType: [String : Int].self) { [weak self] result in
      switch result {
      case .success(let result):
        print(result)
        if itemType == .directory {
          deleteChildren()
        }
        self?.getItems()
      case .failure(let error):
        print(error)
      }
    }

    func deleteChildren() {
      let childrenDeleteRequest = Request(method: .delete,
                                          url: "https://sheetdb.io/api/v1/s7dqserrq6y3s/parentUUID/\(uuid)")
      networkService.sendRequest(request: childrenDeleteRequest, dataType: [String : Int].self) { result in
        switch result {
        case .success(let result):
          print(result)
        case .failure(let error):
          print(error)
        }
      }
    }
  }

  func createItem(parentUUID: String, itemType: ItemType, itemName: String, completion: @escaping (() -> Void?)) {
    let param: [String: Any] = ["data": [["UUID": "\(UUID().uuidString)",
                                          "parentUUID": parentUUID,
                                          "itemType": itemType.rawValue,
                                          "itemName": itemName]]]
    
    let request = Request(method: .post,
                          url: "https://sheetdb.io/api/v1/s7dqserrq6y3s",
                          headers: ["Content-Type": "application/json"],
                          body: param)

    networkService.sendRequest(request: request,
                               dataType: [String: Int].self) { [weak self] result in
      switch result {
      case .success(let result):
        print(result)
        self?.getItems()
        DispatchQueue.main.async {
          completion()
        }
      case .failure(let error):
        print(error)
      }
    }
  }

}
