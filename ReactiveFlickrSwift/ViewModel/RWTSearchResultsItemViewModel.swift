//
//  RWTSearchResultsItem.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/6/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation

class RWTSearchResultsItemViewModel: NSObject {

  let title: String
  let url: NSURL
  var identifier: String

  init(photo: RWTFlickrPhoto) {
    title = photo.title
    url = photo.url
    identifier = photo.identifier
  }

}
