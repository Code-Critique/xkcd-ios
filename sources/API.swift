////  API.swift
// Created: 2019-09-20
//


import Foundation
import UIKit

class XkcdAPI {
  static let endpoint = "https://xkcd.com"
  static let endpointSuffix = "info.0.json"

  static func get(comicId: Int, result: @escaping (_ xkcdComicModel: XKCDComicModel?) -> Void) {
    var url = URL(string: endpoint)!
    if comicId > 0 {
      url.appendPathComponent(String(comicId))
    }
    url.appendPathComponent(endpointSuffix)
    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      guard let data = data, error == nil else {
        print(error?.localizedDescription ?? "No data")
        return
      }
      do {
        var xkcdComicModel = try JSONDecoder().decode(XKCDComicModel.self, from: data)
        let imageUrl = URL(string: xkcdComicModel.imageUrl)!
        let imageTask = URLSession.shared.dataTask(with: imageUrl) { data, _, error in
          guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No Image data")
            return
          }
          xkcdComicModel.image = UIImage(data: data)
          result(xkcdComicModel)
        }
        imageTask.resume()
      } catch {
        print(error)
      }
    }

    task.resume()
  }
}

