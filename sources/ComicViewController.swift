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

  let xkcdModelController = XKCDModelController()
  var historyStack = ComicStack()
  var futureStack = ComicStack()
  var currentComic: ComicModel? {
    didSet {
      comicImageView.image = currentComic?.image
    }
  }

  // MARK: LIFE CYCLE METHODS

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator.startAnimating()

    populate()
    nextComic()
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
    currentComic = futureStack.pop()
  }

  private func previousComic() {
    guard let previousComic = historyStack.pop() else {
      return
    }
    if let currentComic = currentComic {
      futureStack.push(currentComic)
    }
    currentComic = previousComic
  }

  // MARK: ACTIONS

  @objc func handleBackGesture(_ sender: UISwipeGestureRecognizer) {
    previousComic()
  }

  @objc func handleForwardGesture(_ sender: UISwipeGestureRecognizer) {
    nextComic()
  }

  /*
   // MARK: Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}

//extension: Data Source
extension ComicViewController: XKCDModelControllerDelegate {

  private func populate() {
    xkcdModelController.delegate = self
    loadFutureStack()
  }

  private func loadFutureStack() {
    // HardCoded First instance remove and replace with activity indicator
    futureStack.push(ComicModel(
      id: 1,
      title: "One",
      imageURL: URL(fileURLWithPath: "www"),
      image: UIImage(named: "Image")!)
    )
    xkcdModelController.fetchRandom(count: 5, includeMostRecent: true)
  }

  func onComplete(comics: [XKCDComicModel]) {
    _ = comics.map { futureStack.push(ComicModel(id: $0.comicId,
                                     title: $0.title,
                                     imageURL: URL(string: $0.imageUrl)!,
                                     image: $0.image))
    }
  }
}




