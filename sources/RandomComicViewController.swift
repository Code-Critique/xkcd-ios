//
//  RandomComicViewController.swift
//  xkcd
//
//  Created by Ekam Singh Dhaliwal on 2019-09-04.
//

import UIKit

class RandomComicViewController: UIViewController {

  @IBOutlet weak var comicImage: UIImageView!

  override func viewDidLoad() {
        super.viewDidLoad()
    }

  @IBAction func generateComic(_ sender: UIButton) {

    fetchComicData(completion: displayImage(comic:))

  }

  func generateRandomNumber() -> Int {
    return Int.random(in: 0 ... 2198)
  }

  func fetchComicData(completion: @escaping (ComicModel) -> Void) {
    let number = generateRandomNumber()
    let urlString = "https://xkcd.com/\(number)/info.0.json"
    let url = URL(string: urlString)
    let session = URLSession.shared.dataTask(with: url!) { (data, _, _) in

      let jsonDecoder = JSONDecoder()

      guard let data = data else {
        print("No data has been returned")
        return

      }
      do {
        let comicInfo = try jsonDecoder.decode(ComicModel.self, from: data)
        completion(comicInfo)

      } catch {
        print("Failed at decoding")
      }
    }

    session.resume()
  }

  func displayImage(comic: ComicModel) {
    let session = URLSession.shared.dataTask(with: comic.imageURL) { (data, _, _) in

      guard let data = data else {
        print("No data has been returned")
        return
      }
      let image = UIImage(data: data)
      DispatchQueue.main.async {
        self.comicImage.image = image
      }

    }
    session.resume()
  }

}
