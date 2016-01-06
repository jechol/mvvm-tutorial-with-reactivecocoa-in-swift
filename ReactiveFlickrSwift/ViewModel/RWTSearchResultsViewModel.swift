//
//  RWTSearchResultsViewModel.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTSearchResultsViewModel: NSObject {

  let title: String
  var searchResults: [RWTSearchResultsItemViewModel]

  init(searchResults: RWTFlickrSearchResults) {
    self.title = searchResults.searchString
    self.searchResults = searchResults.photos.map { RWTSearchResultsItemViewModel(photo: $0) }

    super.init()
  }
}
