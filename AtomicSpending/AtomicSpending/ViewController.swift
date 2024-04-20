//
//  ViewController.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import UIKit
import SwiftUI


class ViewController: UIViewController {
  
  var data: [Item] = []
  var budgets: [Category: Float] = [:]
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.data = getItemMockData()
    self.budgets = getBudgetMockData()
    setUpPieChartView()
    
    
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 2),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.heightAnchor.constraint(equalToConstant: view.bounds.height / 2)
    ])
  }
  
  func getItemMockData() -> [Item] {
    let mockData = [
      Item(category: Category.housing, description: "Rent", expense: 300.13, date: Date()),
      Item(category: Category.food, description: "Chipotle", expense: 5.23, date: Date()),
      Item(category: Category.utilies, description: "Water", expense: 84.29, date: Date()),
      
    ]
    
    return mockData;
  }
  
  
  func getBudgetMockData() -> [Category: Float] {
    let mockData: [Category: Float] = [
      Category.housing: 500.0,
      Category.utilies: 100.0,
      Category.insurance: 100.0,
      Category.medical: 100.0,
      Category.food: 200.0,
      Category.personal: 100.0,
      Category.debtPayment: 100.0
    ]
    return mockData
  }
  
  func setUpPieChartView() {
    let hostingController = UIHostingController(rootView: SectorChart(data: data))
    addChild(hostingController)
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
    
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      
      hostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      
      hostingController.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
      hostingController.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5) // Set height to half of the parent view's height
    ])
    
  }
}

extension ViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Category.allCases.count - 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryExpenseCell
    cell.categoryLabel.text = Category.allCases[indexPath.row].rawValue
    
    let category = Category.allCases[indexPath.row]
    let categoryData = data.filter {$0.category == category}
    let barChartUI = BarChart(data: categoryData, budget: budgets[category] ?? Float.infinity)
    let hostingController = UIHostingController(rootView: barChartUI)
    cell.contentView.addSubview(hostingController.view)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hostingController.view.leadingAnchor.constraint(equalTo: cell.categoryLabel.trailingAnchor, constant: 15),
      hostingController.view.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, multiplier: 0.5),
      
      hostingController.view.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
      hostingController.view.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.75),
      hostingController.view.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor, multiplier: 0.5)
    ])
    return cell
  }
}
