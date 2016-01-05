//
//  RWTFlickrSearch.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTFlickrSearch {

  func flickrSearchSignal(searchString: String) -> SignalProducer<[RWTFlickrPhoto], NoError> {
    return SignalProducer.empty
      .on(next: { NSLog("\($0)") })
      .delay(2.0, onScheduler: backgroundScheduler())
      .on(next: { NSLog("\($0)") })
  }
}
