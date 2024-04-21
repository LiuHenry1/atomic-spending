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

struct BarChart: View {
  private var data: ExpenseByCategory
  private var budget: Double
  private var formatter: NumberFormatter
  
  init(data: ExpenseByCategory, budget: Double) {
    self.data = data
    self.budget = budget
    self.formatter = NumberFormatter()
    self.formatter.numberStyle = .currency
  }
  
  var body: some View {
    GeometryReader { geometry in
      Chart() {
        BarMark(x: .value("Expense", data.expense))
          .annotation(position: .trailing) {
            Text(formatter.string(from: data.expense as NSNumber)!)
          }
        RuleMark(x: .value("Budget", budget)).foregroundStyle(.red)
      }
    }
  }
}

struct SectorChart: View {
  private var data: [ExpenseByCategory]
  private var total: Double {
    data.reduce(0, {$0 + $1.expense})
  }
  
  private var formatter: NumberFormatter
  
  init(data: [ExpenseByCategory]) {
    self.data = data
    self.formatter = NumberFormatter()
    self.formatter.numberStyle = .percent
  }
  
  var body: some View {
    GeometryReader { geometry in
      Chart(data) { expenseByCategory in
        if total != 0 {
          SectorMark(
            angle: .value("Expense", expenseByCategory.expense),
            innerRadius: .ratio(0.618),
            angularInset: 1.5
          )
          .cornerRadius(5)
          .foregroundStyle(by: .value("Category", expenseByCategory.category.rawValue))
          .annotation(position: .overlay) {
            Text(verbatim: (expenseByCategory.expense / total != 0) ? formatter.string(from: NSNumber(value: expenseByCategory.expense / total))! : "")
              .font(.headline)
              .fontWeight(.bold)
              .padding(5)
          }
        } else {
          SectorMark(
            angle: .value("Expense", 1),
            innerRadius: .ratio(0.618),
            angularInset: 1.5
          )
          .cornerRadius(5)
          .foregroundStyle(Color.gray)
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
