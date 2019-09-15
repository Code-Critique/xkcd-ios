//
//  CommicModel.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-06.
//

import UIKit

struct ComicModel: Codable {
  let id: Int
  let title: String
  let imageURL: URL
  var image: UIImage?

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case imageURL = "img"
  }
}
