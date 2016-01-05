//
//  RWTFlickrPhoto.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation

class RWTFlickrPhoto {

  let title :String
  let url :NSURL
  let identifier :String

  init (title: String, url: NSURL, identifier: String) {
    self.title = title
    self.url = url
    self.identifier = identifier
  }

}
