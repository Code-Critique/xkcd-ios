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
    case id // swiftlint:disable:this identifier_name
    case title
    case imageURL = "img"
  }
}
