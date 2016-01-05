//
// Created by Jechol Lee on 1/5/16.
// Copyright (c) 2016 Reactive Cocoa. All rights reserved.
//

import Foundation

class RWTFlickrSearchViewModel: NSObject {

  dynamic var searchText = "search text"
  dynamic var title = "Flickr Search"

  override init() {
    super.init()

    let validSearchSignal = RACObserve(self, keyPath: "searchText")
      .toSignalProducer()
      .map { $0 as! String }
      .map { $0.characters.count > 3 }
      .skipRepeats()

    validSearchSignal.startWithNext { NSLog("search text is valid: \($0)") }
  }

}
