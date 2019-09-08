//
//  Comic.swift
//  xkcd
//
//  Created by Ekam Singh Dhaliwal on 2019-09-07.
//

import Foundation

struct Comic: Codable {
  var month: String
  var num: Int
  var link: String?
  var year: String
  var news: String?
  var transcript: String
  var img: String
  var title: String

//  enum CodingKeys: String, CodingKey {
//    case month
//    case num
//    case link
//    case year
//    case news
//    case transcript
//    case img
//    case title
//  }
}
