//
//  BackStack.swift
//  xkcd
//
//  Created by thomas minshull on 2019-09-06.
//

import Foundation

class BackStack {
  private var array = [CommicModel]()

  func peek() -> CommicModel? {
    return array.last
  }

  func pop() -> CommicModel? {
    return array.popLast()
  }

  func push(_ newElement: CommicModel) {
    array[array.endIndex] = newElement
  }
}
