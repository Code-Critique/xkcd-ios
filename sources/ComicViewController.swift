//
//  CommicViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-09.
//

import UIKit

class ComicViewController: UIViewController {
  private let comicImageView = UIImageView()
  private lazy var tagsCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    let tagsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
    tagsCollectionView.register(AddTagCell.self, forCellWithReuseIdentifier: "AddCell")
    tagsCollectionView.dataSource = self.tagsDataSource
		tagsCollectionView.delegate = self

    tagsCollectionView.layer.cornerRadius = 8.0
    tagsCollectionView.layer.borderWidth = 1.0
    tagsCollectionView.layer.borderColor = UIColor.black.cgColor

    tagsCollectionView.backgroundColor = .lightGray
    return tagsCollectionView
  }()

  private let tagsDataSource = TagListDataSource()
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
    view.addSubview(tagsCollectionView)
  }

  private func addConstraints() {
    comicImageView.translatesAutoresizingMaskIntoConstraints = false
    tagsCollectionView.translatesAutoresizingMaskIntoConstraints = false

    view.centerXAnchor.constraint(equalTo: comicImageView.centerXAnchor).isActive = true
    view.centerXAnchor.constraint(equalTo: tagsCollectionView.centerXAnchor).isActive = true

    comicImageView.widthAnchor.constraint(equalTo: comicImageView.heightAnchor).isActive = true
    tagsCollectionView.widthAnchor.constraint(equalTo: tagsCollectionView.heightAnchor).isActive = true

    comicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
    tagsCollectionView.topAnchor.constraint(equalTo: comicImageView.bottomAnchor).isActive = true

    view.widthAnchor.constraint(equalTo: comicImageView.widthAnchor, constant: 40.0).isActive = true
    view.widthAnchor.constraint(equalTo: tagsCollectionView.widthAnchor, constant: 40.0).isActive = true
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
        self.currentComic?.image = image // ToDo find a better place to set this
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

extension ComicViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if collectionView.cellForItem(at: indexPath) is AddTagCell {
			let tagListViewController = TagListViewController()
			present(tagListViewController, animated: true)
		}
	}
}
