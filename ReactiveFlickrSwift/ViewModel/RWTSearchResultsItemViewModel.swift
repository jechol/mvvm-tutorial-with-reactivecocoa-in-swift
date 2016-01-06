//
//  RWTSearchResultsItem.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/6/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTSearchResultsItemViewModel: NSObject {

  let isVisible = MutableProperty<Bool>(false)
  let favourites = MutableProperty<Int?>(nil)
  let comments = MutableProperty<Int?>(nil)

  let title: String
  let url: NSURL
  var identifier: String

  let flickrSearch = RWTFlickrSearch()

  init(photo: RWTFlickrPhoto) {
    title = photo.title
    url = photo.url
    identifier = photo.identifier

    super.init()

    let isVisibleSignal = isVisible.producer.skip(1)

    let visibleSignal = isVisibleSignal.filter { $0 }
    let hiddenSignal = isVisibleSignal.filter { !$0 }.map { _ in () }

    let fetchMetadata = visibleSignal
      .delay(1, onScheduler: backgroundScheduler())
      .observeOn(UIScheduler())
      .takeUntil(hiddenSignal)

    fetchMetadata.flatMap(.Latest) { _ in self.flickrSearch.flickrImageMetadata(self.identifier).mapError { $0 as! NoError } }
      .startWithNext { meta in
        self.favourites.value = meta.favourites
        self.comments.value = meta.comments
    }
  }
  
}
