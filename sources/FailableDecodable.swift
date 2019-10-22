//
//  FailableDecodable.swift
//  Tests
//
//  Created by Nathan Wainwright on 2019-10-21.
//

import Foundation

struct FailableDecodable<Base: Decodable>: Decodable {
  let base: Base?

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.base = try? container.decode(Base.self)
  }
}
