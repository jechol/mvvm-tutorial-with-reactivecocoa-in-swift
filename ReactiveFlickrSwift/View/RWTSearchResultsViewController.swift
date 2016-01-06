//
//  RWTSearchResultsViewController.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/6/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import UIKit

class RWTSearchResultsViewController: UITableViewController {

  var viewModel: RWTSearchResultsViewModel! {
    didSet {
      self.bindViewModel()
    }
  }

  func bindViewModel() {
    self.title = self.viewModel.title
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.searchResults.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RWTSearchResultsTableViewCell
    cell.viewModel = viewModel.searchResults[indexPath.row]
    
    return cell
  }

}
