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

}
