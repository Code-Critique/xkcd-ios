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
    case comicId = "comic_ids"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    comicId = try container.decode([Int].self, forKey: .comicId)

    guard comicId.count != 0 else {
      throw XKCDError.failedToParseTag
    }

    return
  }

  init(title: String, comicId: [Int]) {
    self.title = title
    self.comicId = comicId
  }
}

extension Tag: Hashable { }
