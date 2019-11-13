////  ComicDetailsViewController.swift
// Created: 2019-09-21
//

import UIKit

class ComicDetailsViewController: UIViewController {
  enum SearchTagSection: CaseIterable {
    case onlySection
  }

  private var tagTableViewDataSource: UITableViewDiffableDataSource<SearchTagSection, Tag>?
  private var networkManager = NetworkManager()
  private var tags: [String]?
  private var fetchedTags: [Tag]?
  private var sampleFetchedTags = [Tag]()
  private var sampleCurrentTagsList: [Tag]?
  private var sampleUserInputTag: Tag? {
    didSet {
      setAddTagButtonEnable(sampleUserInputTag != nil)
    }
  }

  var comic: ComicModel? {
    didSet {
      comicImageView.image = comic?.image
    }
  }

  // MARK: UI Elements PREV
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
    tagTextField.clearButtonMode = UITextField.ViewMode.whileEditing
    return tagTextField
  }()

  fileprivate let addTagButton: UIButton = {
    let addTagButton = UIButton(frame: CGRect.zero)
    addTagButton.setTitle("Add", for: .normal)
    addTagButton.contentEdgeInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    addTagButton.backgroundColor = UIColor.blue
    addTagButton.layer.cornerRadius = 3.0
    addTagButton.addTarget(self, action: #selector(onAddTag), for: .touchDown)
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
    setUpTagTextField()
    setAddTagButtonEnable(false)

    networkManager.fetchTags { [weak self] (result) in
      switch result {
      case .success(let tags):
        var snapShot = NSDiffableDataSourceSnapshot<SearchTagSection, Tag>()
        snapShot.appendSections([SearchTagSection.onlySection])
        snapShot.appendItems(tags)
        DispatchQueue.main.async {
          self?.tagTableViewDataSource?.apply(snapShot)
        }
      case .failure(let error):
        print("Error: ", error)
      }
    }
		testOverrideTableViewData() // Temp for development purposes todo remove this line 
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
    stackContainer.distribution = .fill
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
		addTagButton.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
		addTagButton.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)

		//contentCompressionResistancePriority(for: <#T##NSLayoutConstraint.Axis#>)
		//addTagButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    addTagButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

    searchTagTableView.widthAnchor.constraint(equalTo: stackContainer.widthAnchor).isActive = true

    stackContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    stackContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    stackContainer.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    stackContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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

  fileprivate func setAddTagButtonEnable(_ enable: Bool) {
    if enable {
      addTagButton.isUserInteractionEnabled = true
      addTagButton.alpha = 1.0
    } else {
      addTagButton.isUserInteractionEnabled = false
      addTagButton.alpha = 0.20
    }
  }

  fileprivate func loadTags() {
    tags = ["Astronomy", "Discovery", "Futility", "Survival", "Scientist"].sorted()
  }

  fileprivate func testOverrideTableViewData() {
    let tagSample = ["Action", "Adventure", "Apocalyptic", "Astronomy", "Autobiographical",
                     "Aviation", "Biographical", "British girls", "Christmas", "Comedy", "Crime",
                     "Crossover", "Detective", "Discovery", "Disney", "Drama", "Dystopian",
                     "Educational", "Educational web‎", "Erotic", "Fantasy", "Feminist", "Futility",
                     "Funny", "Historical", "Horror", "Humor", "Jungle", "Magical girl", "Martial arts",
                     "Military ‎", "Music-themed", "Mystery", "Nautical", "Neo-noir", "Non-fiction",
                     "Pantomime", "Photonovels", "Pirate", "Religious", "Romance", "School-themed",
                     "Science fiction", "Slice of life", "Comics spin-offs‎", "Sports", "Spy",
                     "Superhero‎", "Text", "Webtoons", "Western", "Workplace", "Yuri"].sorted()


		sampleFetchedTags = tagSample.map { (title) -> Tag in
			Tag(title: title, comicId: [Int]())
		}

    updateSearchTagTableView(tagArray: sampleFetchedTags)
  }

  fileprivate func setUpTagTextField() {
    tagTextField.delegate = self
  }

  fileprivate func searchTextFieldHandler(_ textField: UITextField, range: NSRange, string: String, shouldClean: Bool) {
    guard let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
      return
    }

    guard !sampleFetchedTags.isEmpty else {
      return
    }
    // disable Add Button
    sampleUserInputTag = nil

    // search similar
    let keyWord = updatedString.trimmingCharacters(in: .whitespaces)
    if keyWord.isEmpty || shouldClean {  //show full list
      updateSearchTagTableView(tagArray: sampleFetchedTags)
      return
    }

    let similarTagArray = sampleFetchedTags.filter({ (tag) -> Bool in
      return tag.title.lowercased().contains(keyWord.lowercased())
    })

    if !similarTagArray.isEmpty {
      updateSearchTagTableView(tagArray: similarTagArray)
    }

    sampleUserInputTag = sampleFetchedTags.first(where: { $0.title.lowercased() == keyWord.lowercased() })

  }

  fileprivate func updateSearchTagTableView(tagArray: [Tag]) {
    // MARK: todo:  this isn't seems like a popoer way to reload tableview,
    // but searchTagTableView.reloadData() is not working
    sampleCurrentTagsList = tagArray

    var snapShot = NSDiffableDataSourceSnapshot<SearchTagSection, Tag>()
    snapShot.appendSections([SearchTagSection.onlySection])
    snapShot.appendItems(tagArray)

    DispatchQueue.main.async {
      self.tagTableViewDataSource?.apply(snapShot)
    }
  }

  // MARK: Network Manager Post
  fileprivate func postUserTag(tag: Tag?, comicModel: ComicModel?) {
    // todo implent posting new tag
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

  @objc
  fileprivate func onAddTag() {
    print("add! \(String(describing: sampleUserInputTag)) \(String(describing: comic))")
    postUserTag(tag: sampleUserInputTag, comicModel: comic)
    tags?.append(sampleUserInputTag!.title)
    self.tagCollectionView.reloadData()
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let row = indexPath.row
    sampleUserInputTag = sampleCurrentTagsList?[row]
    tagTextField.text = sampleCurrentTagsList?[row].title
  }
}

class TagTableViewCell: UITableViewCell {

}

class TagCollectionViewCell: UICollectionViewCell {
  var textLabel: UILabel = {
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

    contentView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
      contentView.rightAnchor.constraint(equalTo: rightAnchor, constant: 8),
      contentView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
      ])

    addSubview(textLabel)

    NSLayoutConstraint.activate([
      textLabel.topAnchor.constraint(equalTo: topAnchor),
      textLabel.heightAnchor.constraint(equalTo: heightAnchor),
      widthAnchor.constraint(equalTo: textLabel.widthAnchor, constant: 8),
      textLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])

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

extension ComicDetailsViewController: UITextFieldDelegate {
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    searchTextFieldHandler(textField, range: range, string: string, shouldClean: false)
    return true
  }
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    searchTextFieldHandler(textField, range: NSRange(), string: "", shouldClean: true)
    return true
  }
}
