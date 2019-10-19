//
//  TagsListDataSource.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-19.
//

import UIKit

class TagListDataSource: NSObject {
  private var tags = [Tag(title: "Hello World", comicId: [12]), Tag(title: "Happy", comicId: [1])] //[Tag]()
}

extension TagListDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tags.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    cell.textLabel?.text = tags[indexPath.row].title
    return cell
  }
}

extension TagListDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags.count + 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let row = indexPath.row

    guard row <= tags.count, row >= 0 else {
      return UICollectionViewCell()
    }

    if row == tags.count {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath) as? AddTagCell else {
        return UICollectionViewCell()
      }

      return cell
    }

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCollectionViewCell else {
      return UICollectionViewCell()
    }

    let tag = tags[indexPath.row]
    cell.textLabel.text = tag.title
    return cell
  }
}

class AddTagCell: UICollectionViewCell {
  private var textLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.text = "+"
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
