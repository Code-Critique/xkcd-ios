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

  lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
  }()

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
    loadFutureStack()
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
    // TODO - Added by Arun
    // commenting the next line because we are still loading this view fro the storyboard
    // view.translatesAutoresizingMaskIntoConstraints = false
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
    comicImageView.addGestureRecognizer(tapGestureRecognizer)
  }

  private func loadFutureStack() { // HardCoded Mock Data ToDo remove and replace
    futureStack.push(ComicModel(
      id: 1,
      title: "One",
      imageURL: URL(fileURLWithPath: "www"),
      image: UIImage(named: "Image")!)
    )

    futureStack.push(ComicModel(
      id: 2,
      title: "Two",
      imageURL: URL(fileURLWithPath: "www"),
      image: UIImage(named: "Image2")!)
    )

    futureStack.push(ComicModel(
      id: 3,
      title: "Three",
      imageURL: URL(fileURLWithPath: "www"), image: UIImage(named: "Image3")!)
    )

    futureStack.push(ComicModel(
      id: 4,
      title: "Four",
      imageURL: URL(fileURLWithPath: "www"),
      image: UIImage(named: "Image4")!)
    )

    futureStack.push(ComicModel(
      id: 5,
      title: "Five",
      imageURL: URL(fileURLWithPath: "www"),
      image: UIImage(named: "Image5")!)
    )
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

  private func showDetails() {
    let comicDetailsViewController = ComicDetailsViewController()
    comicDetailsViewController.comicId = currentComic?.id
    comicDetailsViewController.comicImage = currentComic?.image
    let navigationController = UINavigationController(rootViewController: comicDetailsViewController)
    present(navigationController, animated: false)
  }

  // MARK: ACTIONS

  @objc func handleBackGesture(_ sender: UISwipeGestureRecognizer) {
    previousComic()
  }

  @objc func handleForwardGesture(_ sender: UISwipeGestureRecognizer) {
    nextComic()
  }

  @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
    showDetails()
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
