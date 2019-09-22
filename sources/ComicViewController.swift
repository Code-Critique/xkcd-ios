//
//  CommicViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-09.
//

import UIKit

class ComicViewController: UIViewController {
  let comicImageView = UIImageView()

  lazy var backGestureRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeGesture.direction = .right
    return swipeGesture
  }()

  lazy var forwardGestureRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleForwardGesture(_:)))
    swipeGesture.direction = .left
    return swipeGesture
  }()

  var historyStack = ComicStack()
  var futureStack = ComicStack()
  var currentComic: ComicModel?

  // MARK: LIFE CYCLE METHODS

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()
    fetchComicData(completion: displayImage(comic:))
  }

  private func setupSubViews() {
    addSubViews()
    addConstraints()
    setUpCommicImageView()
  }

  // MARK: SETUP

  private func addSubViews() {
    view.addSubview(comicImageView)
  }

  private func addConstraints() {
    view.translatesAutoresizingMaskIntoConstraints = false
    comicImageView.translatesAutoresizingMaskIntoConstraints = false

    view.centerXAnchor.constraint(equalTo: comicImageView.centerXAnchor).isActive = true

    comicImageView.widthAnchor.constraint(equalTo: comicImageView.heightAnchor).isActive = true
    comicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
    view.widthAnchor.constraint(equalTo: comicImageView.widthAnchor, constant: 40.0).isActive = true
  }

  private func setUpCommicImageView() {
    comicImageView.contentMode = .scaleAspectFit
    comicImageView.isUserInteractionEnabled = true
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(backGestureRecognizer)
    view.addGestureRecognizer(forwardGestureRecognizer)
  }


  // MARK: UTILITIES

  private func nextComic() {
    if let currentComic = currentComic {
      historyStack.push(currentComic)
    }
     fetchComicData(completion: displayImage(comic:))
  }

  private func previousComic() {
    guard let previousComic = historyStack.pop() else {
      return
    }
    displayImage(comic: previousComic)
    if let currentComic = currentComic {
      futureStack.push(currentComic)
    }
    currentComic = previousComic
  }

  private func generateRandomNumber() -> Int {
      return Int.random(in: 0 ... 2198)
    }

  // MARK: ACTIONS

  @objc func handleBackGesture(_ sender: UISwipeGestureRecognizer) {
    previousComic()
  }

  @objc func handleForwardGesture(_ sender: UISwipeGestureRecognizer) {
    nextComic()
  }

   private func fetchComicData(completion: @escaping (ComicModel) -> Void) {

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

   private func displayImage(comic: ComicModel) {
     let session = URLSession.shared.dataTask(with: comic.imageURL) { (data, _, _) in

       guard let data = data else {
         print("No data has been returned")
         return
       }
       let image = UIImage(data: data)
       DispatchQueue.main.async {
        self.currentComic = comic
        self.comicImageView.image = image
       }

     }
     session.resume()
   }

}
