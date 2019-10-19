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
