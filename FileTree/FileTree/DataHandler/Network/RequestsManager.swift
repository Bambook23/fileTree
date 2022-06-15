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

}

final class RequestsManager: NetworkManager {

  weak var delegate: NetworkManagerDelegate?

  let networkService = APINetworkService()

  func getItems() {
    let request = Request(method: .get, url: "https://sheetdb.io/api/v1/ijtc8qex0zds3")
    networkService.sendRequest(request: request, dataType: DirectoryObject.self) { result in

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

}
