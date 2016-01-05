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

  var viewModel = RWTFlickrSearchViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    bindViewModel()
  }

  func bindViewModel() {
    self.title = self.viewModel.title
    self.searchTextField.rac_textSignal().toSignalProducer().startWithNext { (text) -> () in
      self.viewModel.searchText = text as! String
    }
    self.searchButton.rac_command = toRACCommand(self.viewModel.executeSearch)
  }

}
