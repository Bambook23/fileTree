//
//  RequestsManager.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

protocol NetworkManager {

  func getItems()

}

final class RequestsManager: NetworkManager {

  let networkService = APINetworkService()

  func getItems() {
    let request = Request(method: .get, url: "https://sheetdb.io/api/v1/ijtc8qex0zds3")
    networkService.sendRequest(request: request, dataType: DirectoryObject.self) { result in

      switch result {
      case .success(let items):
        print(items)
      case .failure(let error):
        print(error)
      }
    }
  }

}
