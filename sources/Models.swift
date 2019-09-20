////  Models.swift
// Created: 2019-09-04
//

import Foundation
import UIKit

struct XKCDComicModel: Codable {
  let comicId: Int
  let alt: String
  let imageUrl: String
  let title: String
  var image: UIImage?

  enum CodingKeys: String, CodingKey {
    case comicId = "num"
    case alt
    case imageUrl = "img"
    case title
  }

}


