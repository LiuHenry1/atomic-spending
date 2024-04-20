//
//  Section.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/19/24.
//

import Foundation


struct DateSection {
  var day: Date
  var items: [Item]
  
  init(day: Date) {
    self.day = day
    self.items = [Item]()
  }
}
