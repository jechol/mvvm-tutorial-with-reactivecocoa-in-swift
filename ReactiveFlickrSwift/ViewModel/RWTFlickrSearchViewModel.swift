//
// Created by Jechol Lee on 1/5/16.
// Copyright (c) 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTFlickrSearchViewModel: NSObject {

  dynamic var searchText = "search text"
  dynamic var title = "Flickr Search"

  var executeSearch: Action<AnyObject?, NSString, NSError>!

  override init() {
    super.init()

    let validSearchSignal = RACObserve(self, keyPath: "searchText")
      .toSignalProducer()
      .map { $0 as! String }
      .map { $0.characters.count > 3 }
      .skipRepeats()

    validSearchSignal.startWithNext { NSLog("search text is valid: \($0)") }

    let validSearchProp = AnyProperty(initialValue: false, producer: validSearchSignal.mapError { $0 as! NoError })

    self.executeSearch = Action<AnyObject?, NSString, NSError>(enabledIf: validSearchProp,
      { (_) -> SignalProducer<NSString, NSError> in return self.executeSearchSignal()
    })
  }

  func executeSearchSignal() -> SignalProducer<NSString, NSError> {
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
    let scheduler = QueueScheduler(queue: queue)

    return SignalProducer.empty.on(completed: { NSLog("\($0)") })
    .delay(2.0, onScheduler: scheduler).on(completed: { NSLog("\($0)") })
  }

}
