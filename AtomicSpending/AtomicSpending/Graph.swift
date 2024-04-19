//
//  Graph.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import Foundation
import SwiftUI
import Charts

struct SectorChart: View {
  init(data: [Item]) {
    self.data = data
  }
  
  private var data: [Item]
  var body: some View {
    Chart(data) { element in
      SectorMark(
        angle: .value("Category", element.expense),
        innerRadius: .ratio(0.618),
        angularInset: 1.5
      )
      .cornerRadius(5)
      .foregroundStyle(by: .value("Category", element.category.rawValue))
      
    }
  }
}
