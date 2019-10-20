//
//  Tag.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-03.
//

import Foundation

struct Tag: Codable {
  let title: String
  let comicId: [Int]

  enum CodingKeys: String, CodingKey {
    case title
    case comicId = "id"
  }
}

extension Tag: Hashable { }
