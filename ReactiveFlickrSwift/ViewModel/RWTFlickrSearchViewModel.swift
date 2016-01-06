//
// Created by Jechol Lee on 1/5/16.
// Copyright (c) 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

class RWTFlickrSearchViewModel: NSObject {

  dynamic var searchText = "search text"
  dynamic var title = "Flickr Search"

  var executeSearch: Action<AnyObject?, RWTFlickrSearchResults, NSError>!
  var previousSearchSelected: Action<RWTPreviousSearch, RWTFlickrSearchResults, NSError>!
  var searchResult: RWTSearchResultsViewModel!

  let previousSearches = MutableProperty<[RWTPreviousSearch]>([])

  let flickrSearch = RWTFlickrSearch()

  override init() {
    super.init()

    let validSearchSignal = RACObserve(self, keyPath: "searchText")
      .toSignalProducer()
      .map { $0 as! String }
      .map { $0.characters.count > 3 }
      .skipRepeats()

    validSearchSignal.startWithNext { NSLog("search text is valid: \($0)") }

    let validSearchProp = AnyProperty(initialValue: false, producer: validSearchSignal.mapError { $0 as! NoError })

    self.executeSearch = Action<AnyObject?, RWTFlickrSearchResults, NSError>(enabledIf: validSearchProp, { _ in
      return self.executeSearchSignal()
    })

    self.previousSearchSelected = Action<RWTPreviousSearch, RWTFlickrSearchResults, NSError> { (previous: RWTPreviousSearch) in
      self.searchText = previous.searchString
      return self.executeSearchSignal()
    }
  }

  func executeSearchSignal() -> SignalProducer<RWTFlickrSearchResults, NSError> {
    return flickrSearch.flickrSearchSignal(self.searchText).on(next: {
      self.searchResult = RWTSearchResultsViewModel(searchResults: $0)
      self.addToSearchHistory($0)
    })
  }

  private func addToSearchHistory(result: RWTFlickrSearchResults) {
    let matches = previousSearches.value.filter { $0.searchString == self.searchText }

    var previousSearchesUpdated = previousSearches.value

    if matches.count > 0 {
      let match = matches[0]
      var withoutMatch = previousSearchesUpdated.filter { $0.searchString != self.searchText }
      withoutMatch.insert(match, atIndex: 0)
      previousSearchesUpdated = withoutMatch
    } else {
      let previousSearch = RWTPreviousSearch(searchString: searchText, totalResults: result.totalResults, thumbnail: result.photos[0].url)
      previousSearchesUpdated.insert(previousSearch, atIndex: 0)
    }

    if (previousSearchesUpdated.count > 10) {
      previousSearchesUpdated.removeLast()
    }

    previousSearches.value = previousSearchesUpdated
  }

}
