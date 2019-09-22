//
//  BackStack.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-06.
//

import Foundation

class ComicStack {
  private var array = [Comic]()

  func peek() -> Comic? {
    return array.last
  }

  func pop() -> Comic? {
    return array.popLast()
  }

  func push(_ newElement: Comic) {
    array.append(newElement)
  }
}
