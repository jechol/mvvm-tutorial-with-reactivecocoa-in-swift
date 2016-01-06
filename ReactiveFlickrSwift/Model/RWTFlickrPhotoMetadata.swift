//
//  RWTFlickrPhotoMetadata.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/6/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation

class RWTFlickrPhotoMetadata {
  let favourites: Int
  let comments: Int

  init(favourites:Int?, comments: Int?) {
    self.favourites = favourites ?? 0
    self.comments = comments ?? 0
  }
}
