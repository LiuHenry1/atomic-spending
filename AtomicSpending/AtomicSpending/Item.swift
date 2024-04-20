//
//  Item.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import Foundation

struct Item: Identifiable {
  private(set) var id: String
  
  var category: Category
  var description: String
  var expense: Float
  var date: Date
  
  init(category: Category, description: String, expense: Float, date: Date) {
    self.category = category
    self.description = description
    self.expense = expense
    self.date = date
    self.id = UUID().uuidString
  }
}

enum Category: String, CaseIterable {
  
  case housing = "Housing"
  case utilies = "Utilities"
  case food = "Food"
  case personal = "Personal"
  case insurance = "Insurance"
  case medical = "Medical"
  case debtPayment = "Debt Payments"
  case other = "Other"

}
