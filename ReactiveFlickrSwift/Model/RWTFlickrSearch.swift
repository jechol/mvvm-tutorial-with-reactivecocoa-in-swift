//
//  RWTFlickrSearch.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa
import objectiveflickr

class RWTFlickrSearch: NSObject, OFFlickrAPIRequestDelegate {

  private let requests = NSMutableSet()
  private let flickrContext: OFFlickrAPIContext
  private var flickrRequest: OFFlickrAPIRequest?

  override init() {
    let flickrAPIKey = "9d1bdbde083bc30ebe168a64aac50be5";
    let flickrAPISharedSecret = "5fbfa610234c6c23";
    flickrContext = OFFlickrAPIContext(APIKey: flickrAPIKey, sharedSecret:flickrAPISharedSecret)

    super.init()
  }

  func flickrSearchSignal(searchString: String) -> SignalProducer<RWTFlickrSearchResults, NSError> {

    func photosFromDictionary (response: NSDictionary) -> RWTFlickrSearchResults {
      let total = response.valueForKeyPath("photos.total")!.integerValue
      var photos = [RWTFlickrPhoto]()
      if total > 0 {
        let photoArray = response.valueForKeyPath("photos.photo") as! [[String: String]]
        photos = photoArray.map {
          (photoDict) -> RWTFlickrPhoto in
          let url = self.flickrContext.photoSourceURLFromDictionary(photoDict, size: OFFlickrSmallSize)
          return RWTFlickrPhoto(title: photoDict["title"]!, url: url, identifier: photoDict["id"]!)
        }
      }
      return RWTFlickrSearchResults(searchString: searchString, totalResults: total, photos: photos)
    }

    return signalFromAPIMethod("flickr.photos.search",
      arguments: ["text" : searchString, "sort": "interestingness-desc"],
      transform: photosFromDictionary);
  }

  func flickrImageMetadata(photoId: String) -> SignalProducer<RWTFlickrPhotoMetadata, NSError> {

    let favouritesSignal = signalFromAPIMethod("flickr.photos.getFavorites",
      arguments: ["photo_id": photoId]) { (response: NSDictionary) -> NSString in
        return response.valueForKeyPath("photo.total") as! String
    }

    let commentsSignal = signalFromAPIMethod("flickr.photos.getInfo",
      arguments: ["photo_id": photoId]) { (response: NSDictionary) -> NSString in
        return response.valueForKeyPath("photo.comments._text") as! String
    }

    return combineLatest(favouritesSignal, commentsSignal).map { (f, c) -> RWTFlickrPhotoMetadata in
      return RWTFlickrPhotoMetadata(favourites: f.integerValue, comments: c.integerValue)
    }

  }

  private func signalFromAPIMethod<T: AnyObject>(method: String, arguments: [String:String], logging: Bool = false, transform: (NSDictionary) -> T) -> SignalProducer<T, NSError> {

      return SignalProducer { (observer: Observer<T, NSError>, disposable: CompositeDisposable) -> () in

        let flickrRequest = OFFlickrAPIRequest(APIContext: self.flickrContext)
        flickrRequest.delegate = self
        self.requests.addObject(flickrRequest)

        // Success
        let successSignal = self.rac_signalForSelector("flickrAPIRequest:didCompleteWithResponse:", fromProtocol: OFFlickrAPIRequestDelegate.self).doNext({ (obj) -> Void in
          if (logging) {
            NSLog("\(obj)")
          }
        })
          .toSignalProducer().map { $0 as! RACTuple }.map { (req: $0.first as? OFFlickrAPIRequest, resp: $0.second as? NSDictionary) }

        successSignal.filter { $0.req! == flickrRequest }
          .map { $0.resp! }
          .map(transform)
          .startWithNext{ (next: T) -> () in
            observer.sendNext(next)
            observer.sendCompleted()
        }

        // Fail
        let failSignal = self.rac_signalForSelector("flickrAPIRequest:didFailWithError:", fromProtocol: OFFlickrAPIRequestDelegate.self)
          .toSignalProducer()
          .map { $0 as! RACTuple }
          .map {
            (req: $0.first as? OFFlickrAPIRequest, resp: $0.second as? NSError!)
        }

        failSignal.map { $0.resp }
          .startWithNext { (error) -> () in
            observer.sendFailed(error!)
        }

        // Fire
        flickrRequest.callAPIMethodWithGET(method, arguments: arguments)

        // Schedule cleanup
        disposable.addDisposable({ () -> () in
          self.requests.removeObject(flickrRequest)
        })
      }
      
  }
  
}
