////  ComicDetailsViewController.swift
// Created: 2019-09-21
//

import UIKit

class ComicDetailsViewController: UIViewController {
  enum SearchTagSection: CaseIterable {
    case onlySection
  }

  private var tagTableViewDataSource: UITableViewDiffableDataSource<SearchTagSection, Tag>?

  var comic: ComicModel?
  var comicImage: UIImage?
  var tags: [String]?

  // MARK: UI Elements
  fileprivate let comicImageView: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  fileprivate let tagCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.estimatedItemSize = CGSize(width: 30, height: 30)
    layout.sectionInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = UIColor.white
    return collectionView
  }()

  fileprivate let tagTextField: UITextField = {
    let tagTextField = UITextField(frame: CGRect.zero)
    tagTextField.translatesAutoresizingMaskIntoConstraints = false
    tagTextField.borderStyle = .roundedRect
    tagTextField.backgroundColor = .white
    return tagTextField
  }()

  fileprivate let addTagButton: UIButton = {
    let addTagButton = UIButton(frame: CGRect.zero)
    addTagButton.setTitle("Add", for: .normal)
    addTagButton.contentEdgeInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    addTagButton.backgroundColor = UIColor.blue
    addTagButton.layer.cornerRadius = 3.0
    return addTagButton
  }()

  fileprivate var searchTagTableView: UITableView = {
    let tableView = UITableView(frame: CGRect.zero)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  // MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    if let title = comic?.id {
      self.title = String(title)
    } else {
      title = "unknown"
    }

    loadTags()
    setupNavigationBar()
    layoutElements()
    setupTagCollectionView()
    setUpSearchTagTableView()

    let allTags = [Tag(title: "1", comicId: 1), Tag(title: "tag", comicId: 2)]
    let snapShot = NSDiffableDataSourceSnapshot<SearchTagSection, Tag>()
    snapShot.appendSections([SearchTagSection.onlySection])
    snapShot.appendItems(allTags)
    tagTableViewDataSource?.apply(snapShot)

  }

  fileprivate static func createHorizontalRowStack() -> UIStackView {
    let horizontalStackView = UIStackView(frame: CGRect.zero)
    horizontalStackView.axis = .horizontal
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontalStackView.spacing = UIStackView.spacingUseSystem
    horizontalStackView.isLayoutMarginsRelativeArrangement = true
    horizontalStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 8, bottom: 20, trailing: 8)
    return horizontalStackView
  }

  fileprivate static func createColumnStack() -> UIStackView {
    let verticalStackView = UIStackView(frame: CGRect.zero)
    verticalStackView.axis = .vertical
    verticalStackView.translatesAutoresizingMaskIntoConstraints = false
    return verticalStackView
  }

  fileprivate func layoutElements() {

    let stackContainer = ComicDetailsViewController.createColumnStack()
    let topRow = ComicDetailsViewController.createHorizontalRowStack()
    let middleRow = ComicDetailsViewController.createHorizontalRowStack()

    topRow.addArrangedSubview(comicImageView)
    topRow.addArrangedSubview(tagCollectionView)

    middleRow.addArrangedSubview(tagTextField)
    middleRow.addArrangedSubview(addTagButton)

    //Establish layout hierarchy
    stackContainer.addArrangedSubview(topRow)
    stackContainer.addArrangedSubview(middleRow)
    stackContainer.addArrangedSubview(searchTagTableView)
    view.addSubview(stackContainer)

    //Add the constraints
    comicImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    comicImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    tagTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    addTagButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    searchTagTableView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    searchTagTableView.widthAnchor.constraint(equalToConstant: 150).isActive = true

    stackContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    stackContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    stackContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
  }

  fileprivate func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel,
      target: self,
      action: #selector(onCancel)
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .save,
      target: self,
      action: #selector(onSave)
    )
    navigationController?.navigationBar.isTranslucent = false
  }

  fileprivate func setUpSearchTagTableView() {
    searchTagTableView.register(TagTableViewCell.self, forCellReuseIdentifier: "TagTableViewCell")
    self.tagTableViewDataSource = makeTagTableViewDataSource()
    searchTagTableView.dataSource = tagTableViewDataSource
    searchTagTableView.delegate = self
  }

  private func makeTagTableViewDataSource() -> UITableViewDiffableDataSource<SearchTagSection, Tag> {
    return UITableViewDiffableDataSource(
    tableView: searchTagTableView) { (tableView, indexPath, tag) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "TagTableViewCell",
        for: indexPath
      )

      cell.textLabel?.text = tag.title
      return cell
    }
  }

  fileprivate func setupTagCollectionView() {
    tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
    tagCollectionView.dataSource = self
    tagCollectionView.delegate = self
  }

  fileprivate func loadTags() {
    tags = ["Astronomy", "Discovery", "Futility", "Survival", "Scientist"].sorted()
  }

  // MARK: Navigation Actions
  @objc
  fileprivate func onSave() {
    //Todo callback
  }

  @objc
  fileprivate func onCancel() {
    dismiss(animated: true)
  }
}

extension ComicDetailsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags?.count ?? 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let tagCell = collectionView.dequeueReusableCell(
      withReuseIdentifier: "TagCell",
      for: indexPath
    ) as? TagCollectionViewCell else {
      return UICollectionViewCell()
    }
    tagCell.textLabel.text = tags?[indexPath.row]
    return tagCell
  }
}

extension ComicDetailsViewController: UICollectionViewDelegate {

}

extension ComicDetailsViewController: UITableViewDelegate {

}

class TagTableViewCell: UITableViewCell {

}

class TagCollectionViewCell: UICollectionViewCell {

  fileprivate var textLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    addSubview(textLabel)

    textLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    textLabel.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    self.widthAnchor.constraint(equalTo: textLabel.widthAnchor, constant: 8).isActive = true
    textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

    layer.cornerRadius = 8.0
  }

  override var isSelected: Bool {
    didSet {
      switch isSelected {
      case true:
        backgroundColor = .blue
        textLabel.textColor = .white
      case false:
        backgroundColor = .clear
        textLabel.textColor = .black
      }
    }
  }
}
