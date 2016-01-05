//
//  Scheduler.swift
//  ReactiveFlickrSwift
//
//  Created by Jechol Lee on 1/5/16.
//  Copyright © 2016 Reactive Cocoa. All rights reserved.
//

import Foundation
import ReactiveCocoa

func backgroundScheduler() -> QueueScheduler {
  let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
  let scheduler = QueueScheduler(queue: queue)

  return scheduler
}
