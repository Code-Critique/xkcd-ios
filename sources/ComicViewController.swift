//
//  CommicViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-09.
//

import UIKit

class ComicViewController: UIViewController {
  private let comicImageView = UIImageView()
  private let networkManager = NetworkManager()

  private lazy var backGestureRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeGesture.direction = .right
    return swipeGesture
  }()

  private lazy var forwardGestureRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleForwardGesture(_:)))
    swipeGesture.direction = .left
    return swipeGesture
  }()

  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
  }()

  private var historyStack = ComicStack()
  private var currentComic: ComicModel?

  // MARK: LIFE CYCLE METHODS

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()
    networkManager.fetchRandomComic { [weak self] (comic) in
      guard let comic = comic else {
        return
      }

      self?.displayImage(comic: comic)
    }
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

  // MARK: UTILITIES

  private func nextComic() {
    if let currentComic = currentComic {
      historyStack.push(currentComic)
    }

    networkManager.fetchRandomComic { [weak self] (comicModel) in
      guard let comicModel = comicModel else {
        return
      }
      self?.displayImage(comic: comicModel)
    }
  }

  private func previousComic() {
    guard let previousComic = historyStack.pop() else {
      return
    }
    displayImage(comic: previousComic)
    currentComic = previousComic
  }

  private func showDetails() {
    let comicDetailsViewController = ComicDetailsViewController()
    comicDetailsViewController.comic = currentComic
    let navigationController = UINavigationController(rootViewController: comicDetailsViewController)
    present(navigationController, animated: false)
  }

  private func displayImage(comic: ComicModel) {
    networkManager.fetchImage(for: comic) { (image) in
      guard let image = image else {
        return
      }

      DispatchQueue.main.async {
        self.currentComic = comic
        self.comicImageView.image = image
      }
    }
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
}
