//
//  RWTFlickrSearchResults.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation


class RWTFlickrSearchResults {

  let searchString: String
  let totalResults: Int
  let photos: [RWTFlickrPhoto]

  init(searchString: String, totalResults: Int, photos: [RWTFlickrPhoto]) {
    self.searchString = searchString
    self.totalResults = totalResults
    self.photos = photos
  }

}
