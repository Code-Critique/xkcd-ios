//
//  CommicModel.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-06.
//

import UIKit

struct ComicModel: Codable {
  let id: Int // swiftlint:disable:this identifier_name
  let title: String
  let imageURL: URL
  var image: UIImage?

  enum CodingKeys: String, CodingKey {
    case id = "num" // swiftlint:disable:this identifier_name
    case title
    case imageURL = "img"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    let urlString = try container.decode(String.self, forKey: .imageURL)

    guard let imageURL = URL(string: urlString) else {
      throw XKCDError.failedToParseURL
    }

    self.imageURL = imageURL
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(imageURL.absoluteString, forKey: .imageURL)
  }
}
