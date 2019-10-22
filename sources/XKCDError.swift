//
//  XKCDError.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-22.
//

import Foundation

enum XKCDError: Error {
  case failedToParseURL
  case failedToParseTagArray
  case failedToParseTag
}
