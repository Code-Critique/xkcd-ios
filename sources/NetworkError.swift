//
//  NetworkError.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-03.
//

import Foundation

enum NetworkError: Error {
  case clientError
  case serverError
  case defaultNetworkError
}
