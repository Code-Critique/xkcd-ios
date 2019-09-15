//
//  CommicViewController.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-09.
//

import UIKit

class CommicViewController: UIViewController {
  let commicImageView = UIImageView()

  lazy var backGesturRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeGesture.direction = .left
    return swipeGesture
  }()

  lazy var forwardGestureRecognizer: UISwipeGestureRecognizer = {
    var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleForwardGesture(_:)))
    swipeGesture.direction = .right
    return swipeGesture
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubViews()
  }

  private func setupSubViews() {
    addSubViews()
    addConstraints()
    setUpCommicImageView()
  }

  private func addSubViews() {
    view.addSubview(commicImageView)
  }

  private func addConstraints() {
    view.translatesAutoresizingMaskIntoConstraints = false
    commicImageView.translatesAutoresizingMaskIntoConstraints = false

    view.centerXAnchor.constraint(equalTo: commicImageView.centerXAnchor).isActive = true
    view.centerYAnchor.constraint(equalTo: commicImageView.centerYAnchor).isActive = true

    commicImageView.widthAnchor.constraint(equalTo: commicImageView.heightAnchor).isActive = true
    commicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50.0).isActive = true
    view.widthAnchor.constraint(equalTo: commicImageView.widthAnchor, constant: 40.0).isActive = true
  }

  private func setUpCommicImageView() {
    commicImageView.image = UIImage(named: "Image")!
    commicImageView.isUserInteractionEnabled = true
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(backGesturRecognizer)
    view.addGestureRecognizer(forwardGestureRecognizer)
  }

  // MARK: - ACTIONS

  @objc func handleBackGesture(_ sender: UISwipeGestureRecognizer) {

  }

  @objc func handleForwardGesture(_ sender: UISwipeGestureRecognizer) {
    
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}
