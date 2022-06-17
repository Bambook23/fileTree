//
//  Request.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

enum HTTPMethod: String {

  case get = "GET"
  case post = "POST"
  case delete = "DELETE"

}

protocol DataRequest {

  var method: HTTPMethod { get }
  var url: String { get }
  var headers: [String: String]? { get }
  var queryItems: [String: String]? { get }
  var body: [String: Any]? { get }

}

struct Request: DataRequest {

  var method: HTTPMethod
  var url: String
  var headers: [String: String]?
  var queryItems: [String: String]?
  var body: [String: Any]?

}
