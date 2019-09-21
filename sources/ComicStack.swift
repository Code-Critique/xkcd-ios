//
//  BackStack.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-06.
//

import Foundation

class ComicStack {
  private var array = [ComicModel]()

  func peek() -> ComicModel? {
    return array.last
  }

  func pop() -> ComicModel? {
    return array.popLast()
  }

  func push(_ newElement: ComicModel) {
    array.append(newElement)
  }
}
