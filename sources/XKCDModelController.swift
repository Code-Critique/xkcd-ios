////  XKCDModelController.swift
// Created: 2019-09-20
//


import Foundation

protocol XKCDModelControllerDelegate {
  func onComplete(comics:[XKCDComicModel])
}

class XKCDModelController {

  var delegate:XKCDModelControllerDelegate?

  var maxComicId:Int?
  var comic = [XKCDComicModel]()

  func fetchComic(comicId:Int, complete: @escaping (_ xkcdComicModel: XKCDComicModel?) -> Void) {
    XkcdAPI.get(comicId: comicId) { result in
      complete(result)
    }
  }
  private func fetchLatestComic(complete result:@escaping (_ xkcdComicModel: XKCDComicModel?) -> Void) {
    fetchComic(comicId: 0, complete:result)
  }

  func fetchRandom(count:Int, includeMostRecent: Bool = true) {
    //Fetch the latest comic first. The id will be the max range for randomness
    var maxElements = count
    guard maxElements > 0 else { return }
    fetchLatestComic { [weak self] xkcdModel in
      guard let xkcdModel = xkcdModel else { return }
      self?.maxComicId = xkcdModel.comicId
      if includeMostRecent {
        self?.comic.append(xkcdModel)
        maxElements -= 1
        self?.maxComicId? -= 1
      }

      for index in 1...maxElements {
        guard let maxComicId = self?.maxComicId,
          let comicId = (1..<maxComicId).randomElement()
          else { return }
        //TODO: Handle collission - We don't wish to have duplicates
        self?.fetchComic(comicId: comicId) { xkcdModel in
          guard let xkcdModel = xkcdModel else { return }
          self?.comic.append(xkcdModel)
          if index == maxElements {
            self?.delegate?.onComplete(comics:self!.comic)
          }
        }
      }

    }
  }
}
