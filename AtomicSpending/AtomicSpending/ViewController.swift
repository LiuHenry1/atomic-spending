//
//  ViewController.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/13/24.
//

import UIKit
import SwiftUI


class ViewController: UIViewController {
  
  var items: [Item] = []
  var budgets: [Category: Int] = [:]
  var expensesByCategory: [ExpenseByCategory] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    getBudgets()
    getItems()
    getExpensesByCategory()
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
      return
    }
    
    let selectedCategory = expensesByCategory[selectedIndexPath.row].category
    
    guard let transactionListViewController = segue.destination as? TransactionListViewController else {
      return
    }
    
    transactionListViewController.category = selectedCategory
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    getItems()
    getBudgets()
    getExpensesByCategory()
    setUpPieChartView()

    tableView.reloadData()
  }
  
  private func getExpensesByCategory(){
    expensesByCategory = []
    for category in Category.allCases {
      let expense = items.filter{$0.category == category}.reduce(0, {acc, item in
        return acc + item.expense
      })
      expensesByCategory.append(ExpenseByCategory(category: category, expense: expense))
    }
  }
  
  private func getItems() {
    self.items = Item.getItems()
  }
  
  
  private func getBudgets() {
    let defaults = UserDefaults.standard
    
    
    var budgets: [Category: Int] = [:]
    for category in Category.allCases {
      let budget = defaults.integer(forKey: category.rawValue)
      budgets[category] = budget
    }
    self.budgets = budgets;
  }
  
  func setUpPieChartView() {
    var sectorChartUI: SectorChart
    if expensesByCategory.reduce(0, {acc, item in acc + item.expense}) != 0 {
      sectorChartUI = SectorChart(data: expensesByCategory)
    } else {
      sectorChartUI = SectorChart(data: [ExpenseByCategory(category: Category.none
                                                           , expense: 0)])
    }
    let hostingController = UIHostingController(rootView: sectorChartUI)
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
    let categoryData = expensesByCategory.first(where: {$0.category == category})
    var barChartUI: BarChart
    barChartUI = BarChart(data: categoryData!, budget: budgets[category] ?? 0)

    let hostingController = UIHostingController(rootView: barChartUI)
    cell.contentView.addSubview(hostingController.view)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hostingController.view.leadingAnchor.constraint(equalTo: cell.categoryLabel.trailingAnchor, constant: 15),
      hostingController.view.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor),
      
      hostingController.view.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
      hostingController.view.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.75),
    ])
    return cell
  }
}
