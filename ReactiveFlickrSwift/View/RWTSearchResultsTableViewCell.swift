//
//  RWTSearchResultsTableViewCell.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/6/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import UIKit
import ReactiveCocoa

class RWTSearchResultsTableViewCell: UITableViewCell {

  @IBOutlet var imageThumbnailView: UIImageView!

  @IBOutlet var titleLabel: UILabel!

  @IBOutlet var commentsIcon: UIImageView!
  @IBOutlet var commentsLabel: UILabel!

  @IBOutlet var favouritesIcon: UIImageView!
  @IBOutlet var favouritesLabel: UILabel!

  var viewModel: RWTSearchResultsItemViewModel! {
    didSet {
      self.bindViewModel()
    }
  }

  func bindViewModel() {
    let photo = viewModel

    titleLabel.text = photo.title
    signalForImage(photo.url).startOn(backgroundScheduler())
      .takeUntil(self.rac_prepareForReuseSignal.toSignalProducer().map { _ in () }.mapError { $0 as! NoError })
      .observeOn(UIScheduler())
      .startWithNext { (image) -> () in
        self.imageThumbnailView.image = image
    }

    photo.favourites.producer.startWithNext {
      self.favouritesLabel.text = $0 == nil ? "" : "\($0!)"
      self.favouritesIcon.hidden = $0 == nil
    }

    photo.comments.producer.startWithNext {
      self.commentsLabel.text = $0 == nil ? "" : "\($0!)"
      self.commentsIcon.hidden = $0 == nil
    }

    photo.isVisible.value = true
    self.rac_prepareForReuseSignal.toSignalProducer().startWithNext { _ in
      self.imageThumbnailView.image = nil
      self.viewModel.isVisible.value = false
    }

  }

  func signalForImage(imageUrl: NSURL) -> SignalProducer<UIImage, NSError> {
    let signal = SignalProducer<UIImage, NSError> {
      (observer, _) in
      let data = NSData(contentsOfURL: imageUrl)!
      let image = UIImage(data: data)!
      observer.sendNext(image)
      observer.sendCompleted()
    }

    return signal
  }

}
