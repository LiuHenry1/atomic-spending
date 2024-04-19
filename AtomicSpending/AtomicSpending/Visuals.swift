//
//  Visuals.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import Foundation
import SwiftUI
import Charts
import UIKit
import DGCharts

struct BarChart: View {
  private var data: [Item]
  private var budget: Float
  private var formatter: NumberFormatter
  
  init(data: [Item], budget: Float) {
    self.data = data.count == 0 ? [Item(category: Category.other, description: "None", expense: 0, date: Date())] : data
    self.budget = budget
    self.formatter = NumberFormatter()
    self.formatter.numberStyle = .currency
  }
  
  var body: some View {
    GeometryReader { geometry in
      Chart(data) { item in
        BarMark(x: .value("Expense", item.expense))
          .annotation(position: .overlay) {
            Text(formatter.string(from: item.expense as NSNumber)!)
          }
        RuleMark(x: .value("Budget", budget)).foregroundStyle(.red)
      }
    }
  }
}

struct SectorChart: View {
  private var data: [Item]
  private var total: Float {
    data.reduce(0) {$0 + $1.expense}
  }
  private var formatter: NumberFormatter
  
  init(data: [Item]) {
    self.data = data
    self.formatter = NumberFormatter()
    self.formatter.numberStyle = .percent
  }
  
  var body: some View {
    GeometryReader { geometry in
      Chart(data) { item in
        SectorMark(
          angle: .value("Expense", item.expense),
          innerRadius: .ratio(0.618),
          angularInset: 1.5
        )
        .cornerRadius(5)
        .foregroundStyle(by: .value("Category", item.category.rawValue))
        .annotation(position: .overlay) {
          Text(verbatim: formatter.string(from: NSNumber(value: item.expense / total))!)
            .font(.headline)
            .fontWeight(.bold)
            .padding(5)
        }
      }
      .chartBackground { chartProxy in
        GeometryReader { geometry in
          let frame = geometry[chartProxy.plotFrame!]
          VStack {
            Text("Total Spending:")
              .font(.callout)
              .foregroundStyle(.secondary)
            Text("$\(String(format: "%.2f", total))")
              .font(.title2.bold())
              .foregroundColor(.primary)
          }
          .position(x: frame.midX, y: frame.midY)
        }
      }
    }
  }
}
