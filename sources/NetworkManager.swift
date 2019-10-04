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
    let url = URL(string: urlString)!
    let dataTask = URLSession.shared.dataTask(with: url) { (data, _, _) in

      let jsonDecoder = JSONDecoder()

      guard let data = data else {
        print("No data has been returned")
        return

      }
      let comicInfo = try? jsonDecoder.decode(ComicModel.self, from: data)
      completion(comicInfo)
    }
    dataTask.resume()
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

  func fetchTags(completion: @escaping ((Result<[Tag], Error>) -> Void)) {
    let urlString = "https://ivggashpl0.execute-api.us-west-2.amazonaws.com/staging/tags"
    let url = URL(string: urlString)!
    let dataTask = URLSession.shared.dataTask(with: url) { (data, response, _) in

      let jsonDecoder = JSONDecoder()

      guard let data = data else {
        guard let response = response as? HTTPURLResponse else {
          completion(.failure(NetworkError.defaultNetworkError))
          return
        }

        switch response.statusCode {
        case (400 ..< 500):
          completion(.failure(NetworkError.clientError))
        case (500 ..< 600):
          completion(.failure(NetworkError.serverError))
        default:
          completion(.failure(NetworkError.defaultNetworkError))
        }

        return
      }

      guard let tags = try? jsonDecoder.decode([Tag].self, from: data) else {
        completion(.failure(XKCDError.failedToParseTagArray))
        return
      }

      completion(.success(tags))
    }
    dataTask.resume()
  }
}
