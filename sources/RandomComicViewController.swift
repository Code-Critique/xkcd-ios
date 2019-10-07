//
//  RandomComicViewController.swift
//  xkcd
//
//  Created by Ekam Singh Dhaliwal on 2019-09-04.
//

import UIKit

class RandomComicViewController: UIViewController {

  let networkManager = NetworkManager()

  @IBOutlet weak var comicImage: UIImageView!

  @IBAction func generateComic(_ sender: UIButton) {
    let randomId = networkManager.generateRandomId()
    networkManager.fetchComicData(id: randomId) { [weak self] (comicModel) in
      guard let comicModel = comicModel else { return }

      self?.networkManager.fetchImage(for: comicModel) { (image) in
        DispatchQueue.main.async {
          self?.comicImage.image = image
        }
      }
    }
  }
}
