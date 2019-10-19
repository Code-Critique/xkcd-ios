//
//  TagListViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-19.
//

import UIKit

class TagListViewController: UIViewController {
  private let dataSource = TagListDataSource()

  private lazy var tagsTableView: UITableView = {
    let tagsTableView = UITableView(frame: .zero)
    tagsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    tagsTableView.dataSource = self.dataSource
    return tagsTableView
  }()

  private func layoutViews() {
    tagsTableView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(tagsTableView)
    tagsTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    tagsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    tagsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tagsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    layoutViews()
  }
}

class TagListDataSource: NSObject, UITableViewDataSource {
  private var tags = [Tag(title: "Hello World", comicId: [12]), Tag(title: "Happy", comicId: [1])] //[Tag]()

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tags.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
    cell.textLabel?.text = tags[indexPath.row].title
    return cell
  }
}
