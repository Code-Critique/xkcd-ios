//
//  PopupViewViewController.swift
//  xkcd
//
//  Created by Shota Iwamoto on 2019-10-04.
//

import UIKit

class PopupViewViewController: UIViewController {

  let baseView = UIView()
  let altTextLabel = UILabel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()

    self.view.backgroundColor = UIColor(red: 150 / 255, green: 150 / 255, blue: 150 / 255, alpha: 0.6)
  }

  private func setupSubViews() {
    let screenWidth = self.view.frame.width
    let screenHeight = self.view.frame.height

    let popupWidth = (screenWidth * 3) / 4
    let popupHeight = (screenWidth * 4) / 4

    baseView.frame = CGRect(x: screenWidth / 8, y: screenHeight / 5, width: popupWidth, height: popupHeight)

    baseView.backgroundColor = UIColor.white
    baseView.layer.cornerRadius = 10

    self.view.addSubview(baseView)
    baseView.addSubview(altTextLabel)
    altTextLabel.numberOfLines = 0
    altTextLabel.lineBreakMode = .byWordWrapping
    altTextLabel.sizeToFit()
    altTextLabel.translatesAutoresizingMaskIntoConstraints = false
    altTextLabel.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 20).isActive = true
    altTextLabel.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20).isActive = true
    altTextLabel.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -20).isActive = true
  }
}
