//
//  CommicViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-09.
//

import UIKit

class ComicViewController: UIViewController {
<<<<<<< HEAD
  let comicImageView = UIImageView()
  let networkManager = NetworkManager()

  lazy var backGestureRecognizer: UISwipeGestureRecognizer = {
=======
  private let comicImageView = UIImageView()
  private lazy var tagsCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    let tagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
    tagsCollectionView.register(AddTagCell.self, forCellWithReuseIdentifier: "AddCell")
    tagsCollectionView.dataSource = self.tagsDataSource

    tagsCollectionView.layer.cornerRadius = 8.0
    tagsCollectionView.layer.borderWidth = 1.0
    tagsCollectionView.layer.borderColor = UIColor.black.cgColor

    tagsCollectionView.backgroundColor = .lightGray
    return tagsCollectionView
  }()

  private let tagsDataSource = TagListDataSource()
  private let networkManager = NetworkManager()

  private lazy var backGestureRecognizer: UISwipeGestureRecognizer = {
>>>>>>> a99641b... Initial Commit
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeGesture.direction = .right
    return swipeGesture
  }()

<<<<<<< HEAD
  lazy var forwardGestureRecognizer: UISwipeGestureRecognizer = {
=======
  private lazy var forwardGestureRecognizer: UISwipeGestureRecognizer = {
>>>>>>> a99641b... Initial Commit
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleForwardGesture(_:)))
    swipeGesture.direction = .left
    return swipeGesture
  }()

<<<<<<< HEAD
  lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
  }()

  var historyStack = ComicStack()
  var futureStack = ComicStack()
  var currentComic: ComicModel?
=======
  private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
  }()

  private var historyStack = ComicStack()
  private var currentComic: ComicModel?
>>>>>>> a99641b... Initial Commit

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
<<<<<<< HEAD
=======
    view.addSubview(tagsCollectionView)
>>>>>>> a99641b... Initial Commit
  }

  private func addConstraints() {
    comicImageView.translatesAutoresizingMaskIntoConstraints = false
<<<<<<< HEAD

    view.centerXAnchor.constraint(equalTo: comicImageView.centerXAnchor).isActive = true

    comicImageView.widthAnchor.constraint(equalTo: comicImageView.heightAnchor).isActive = true
    comicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
    view.widthAnchor.constraint(equalTo: comicImageView.widthAnchor, constant: 40.0).isActive = true
=======
    tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false

    view.centerXAnchor.constraint(equalTo: comicImageView.centerXAnchor).isActive = true
    view.centerXAnchor.constraint(equalTo: tagsCollectionView.centerXAnchor).isActive = true

    comicImageView.widthAnchor.constraint(equalTo: comicImageView.heightAnchor).isActive = true
    tagsCollectionView.widthAnchor.constraint(equalTo: tagsCollectionView.heightAnchor).isActive = true

    comicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
    tagsCollectionView.topAnchor.constraint(equalTo: comicImageView.bottomAnchor).isActive = true

    view.widthAnchor.constraint(equalTo: comicImageView.widthAnchor, constant: 40.0).isActive = true
    view.widthAnchor.constraint(equalTo: tagsCollectionView.widthAnchor, constant: 40.0).isActive = true
>>>>>>> a99641b... Initial Commit
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
<<<<<<< HEAD
    if let currentComic = currentComic {
      futureStack.push(currentComic)
    }
=======
>>>>>>> a99641b... Initial Commit
    currentComic = previousComic
  }

  private func showDetails() {
    let comicDetailsViewController = ComicDetailsViewController()
<<<<<<< HEAD
    comicDetailsViewController.comicId = currentComic?.id
    comicDetailsViewController.comicImage = currentComic?.image
=======
    comicDetailsViewController.comic = currentComic
>>>>>>> a99641b... Initial Commit
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
