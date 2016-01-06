//
//  RWTPreviousSearch.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/7/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation


class RWTPreviousSearch: NSObject {

  let searchString: String
  let totalResults: Int
  let thumbnail: NSURL

  init(searchString: String, totalResults: Int, thumbnail: NSURL) {
    self.searchString = searchString
    self.totalResults = totalResults
    self.thumbnail = thumbnail
  }
}
