//
//  RWTPreviousTableCell.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/7/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import UIKit

class RWTPreviousTableCell: UITableViewCell {

  @IBOutlet var thumbnailImage: UIImageView!
  @IBOutlet var totalResultsLabel: UILabel!
  @IBOutlet var recentSearchLabel: UILabel!

  var viewModel: RWTPreviousSearch! {
    didSet {
      bindViewModel()
    }
  }

  func bindViewModel() {
    
    let previousSearch = viewModel!

    recentSearchLabel.text = previousSearch.searchString
    totalResultsLabel.text = "\(previousSearch.totalResults)"

    let data = NSData(contentsOfURL: previousSearch.thumbnail)
    let image = UIImage(data: data!)
    thumbnailImage.image = image

  }

}
