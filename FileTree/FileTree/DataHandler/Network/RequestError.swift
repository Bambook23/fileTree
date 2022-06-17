//
//  RequestError.swift
//  FileTree
//
//  Created by Andrii Staroselskyi on 14.06.2022.
//

import Foundation

enum RequestError: Error {

    case decodingError
    case invalidURL
    case unknown
  
}
