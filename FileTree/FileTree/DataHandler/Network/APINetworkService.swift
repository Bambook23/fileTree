//
//  APINetworkService.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

protocol NetworkService {

  func sendRequest<T: Decodable>(request: DataRequest, dataType: T.Type, completion: @escaping (Result<[T], RequestError>) -> Void)

}

struct APINetworkService: NetworkService {
  func sendRequest<T>(request: DataRequest, dataType: T.Type, completion: @escaping (Result<[T], RequestError>) -> Void) where T : Decodable {
    guard var urlComponent = URLComponents(string: request.url)
    else { return completion(.failure(.invalidURL)) }

    var queryItems: [URLQueryItem] = []

    request.queryItems?.forEach {
      let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
      queryItems.append(urlQueryItem)
    }

    urlComponent.queryItems = queryItems

    guard let remoteURL = urlComponent.url
    else { return completion(.failure(.invalidURL)) }

    var urlRequest = URLRequest(url: remoteURL)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.allHTTPHeaderFields = request.headers

    if let body = request.body {
      urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }

    print(remoteURL)

    DispatchQueue.main.async {
      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let data = data {
          if let decodedData = try? JSONDecoder().decode([T].self, from: data) {
          completion(.success(decodedData))
          } else { completion(.failure(.decodingError)) }
        } else { completion(.failure(.unknown)) }
      }.resume()
    }
  }

}
