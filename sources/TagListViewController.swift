//
//  TagListViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-10-19.
//

import UIKit

class TagListViewController: UIViewController {
  private let dataSource = TagListDataSource()
	
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
    //addTagButton.addTarget(self, action: #selector(onAddTag), for: .touchDown)
    return addTagButton
  }()

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
/*
extension TagListViewController: UITextFieldDelegate {
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
*/
