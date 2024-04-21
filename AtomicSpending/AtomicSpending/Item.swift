//
//  Item.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import Foundation

struct Item: Identifiable, Codable {
  private(set) var id: String = UUID().uuidString
  
  var category: Category
  var description: String
  var expense: Double
  var date: Date
  
  init(category: Category, description: String, expense: Double, date: Date) {
    self.category = category
    self.description = description
    self.expense = expense
    self.date = date
  }
}

extension Item {
  static var itemsKey: String {
    return "items"
  }
  
  static func save(_ items: [Item]) {
    let encodedDate = try! JSONEncoder().encode(items)
    
    let defaults = UserDefaults.standard
    defaults.set(encodedDate, forKey: Item.itemsKey)
  }
  
  static func getItems() -> [Item] {
    let defaults = UserDefaults.standard
    guard let data = defaults.data(forKey: Item.itemsKey) else {
      return []
    }
    let items = try! JSONDecoder().decode([Item].self, from: data)
    
    return items
  }
  
  func save() {
    var items = Item.getItems()
    if let index = items.firstIndex(where: {item in item.id == self.id} ) {
      items.remove(at: index)
      items.insert(self, at: index)
    } else {
      items.append(self)
    }
    Item.save(items)
  }
}

struct ExpenseByCategory: Identifiable {
  private(set) var id: String = UUID().uuidString
  
  var category: Category
  var expense: Double
  
  init(category: Category, expense: Double) {
    self.category = category
    self.expense = expense
  }
}

enum Category: String, CaseIterable, Codable {
  
  case housing = "Housing"
  case utilies = "Utilities"
  case food = "Food"
  case personal = "Personal"
  case insurance = "Insurance"
  case medical = "Medical"
  case debtPayment = "Debt Payments"
  case none = "none"

}
