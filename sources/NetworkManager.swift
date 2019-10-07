//
//  NetworkManager.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-01.
//

import UIKit

struct NetworkManager {
  func generateRandomId() -> Int {
    return Int.random(in: 0 ... 2198)
  }

  func fetchRandomComic(completion: @escaping (ComicModel?) -> Void) {
    let randomId = generateRandomId()
    fetchComicData(id: randomId, completion: completion)
  }

  func fetchComicData(id: Int, completion: @escaping (ComicModel?) -> Void) { // swiftlint:disable:this identifier_name
    let urlString = "https://xkcd.com/\(id)/info.0.json"
    let url = URL(string: urlString)
    let session = URLSession.shared.dataTask(with: url!) { (data, _, _) in

      let jsonDecoder = JSONDecoder()

      guard let data = data else {
        print("No data has been returned")
        return

      }
      let comicInfo = try? jsonDecoder.decode(ComicModel.self, from: data)
      completion(comicInfo)
    }
    session.resume()
  }

  func fetchImage(for comic: ComicModel, with completion: @escaping ((UIImage?) -> Void)) {
    let session = URLSession.shared.dataTask(with: comic.imageURL) { (data, _, _) in

      guard let data = data else {
        print("No data has been returned")
        return
      }

      let image = UIImage(data: data)
      completion(image)
    }
    session.resume()
  }
}
