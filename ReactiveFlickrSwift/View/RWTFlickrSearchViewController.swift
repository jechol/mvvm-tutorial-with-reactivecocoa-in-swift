//
// Created by Jechol Lee on 1/5/16.
// Copyright (c) 2016 Reactive Cocoa. All rights reserved.
//

import UIKit
import ReactiveCocoa

class RWTFlickrSearchViewController: UIViewController {

  @IBOutlet var searchTextField: UITextField!
  @IBOutlet var searchButton: UIButton!
  @IBOutlet var loadingIndicator: UIActivityIndicatorView!
  @IBOutlet var searchHistoryTable: UITableView!

  var viewModel: RWTFlickrSearchViewModel! {
    didSet {
      self.bindViewModel()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.viewModel = RWTFlickrSearchViewModel()
  }

  func bindViewModel() {
    self.title = self.viewModel.title
    self.searchTextField.rac_textSignal().toSignalProducer().startWithNext { (text) -> () in
      self.viewModel.searchText = text as! String
    }
    self.searchButton.rac_command = toRACCommand(self.viewModel.executeSearch)

    self.viewModel.executeSearch.executing.producer
      .observeOn(UIScheduler())
      .startWithNext { (executing: Bool) -> () in
        UIApplication.sharedApplication().networkActivityIndicatorVisible = executing
        self.loadingIndicator.hidden = !executing

        if (executing) {
          self.searchTextField.resignFirstResponder()
        }
    }

    self.viewModel.executeSearch.values.observeNext { (results) -> () in
      self.performSegueWithIdentifier("ShowResults", sender: self)
    }
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let resultsViewController = segue.destinationViewController as! RWTSearchResultsViewController
    resultsViewController.viewModel = self.viewModel.searchResult!
  }
  
}
