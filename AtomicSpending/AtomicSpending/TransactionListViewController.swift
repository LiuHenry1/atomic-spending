//
//  TransactionListViewController.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/19/24.
//

import UIKit

class TransactionListViewController: UIViewController {
  
  @IBOutlet weak var addButton: UIButton!
  
  var category: Category? = nil
  let expenseFormatter = NumberFormatter()
  let dateFormatter = DateFormatter()
  var items: [Item] = []
  var itemsToDisplay: [Item] = []
  
  @IBOutlet weak var tableView: UITableView!
  var dates: [String] = [String]()
  var dateSections: [DateSection] = [DateSection]()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    addButton.layer.cornerRadius = addButton.frame.width / 2
    expenseFormatter.numberStyle = .currency
    getItems()
    
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getItems()
  }

  private func getItems() {
    items = Item.getItems()
    itemsToDisplay = items
    if let category = category {
      itemsToDisplay = itemsToDisplay.filter{item in item.category == category}
    }
    itemsToDisplay.sort {
      $0.date > $1.date
    }
    
    dateSections = []
    dates = []
    dateFormatter.dateFormat = "MMM dd"
    var offset = DateComponents()
    offset.hour = 24
    var lastDateSection = Calendar.current.date(byAdding: offset, to: Date())
    for item in itemsToDisplay {
      if (!Calendar.current.isDate(item.date, equalTo: lastDateSection!, toGranularity: .day)) {
        let section = DateSection(day: item.date)
        dateSections.append(section)
        dates.append(dateFormatter.string(from: item.date))
        lastDateSection = item.date
      }
      dateSections[dateSections.count - 1].items.append(item)
    }
  
    tableView.reloadData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    var selectedItem: Item? = nil
    if let selectedIndexPath = tableView.indexPathForSelectedRow {
      selectedItem = dateSections[selectedIndexPath.section].items[selectedIndexPath.row]
    }
    
    guard let creationViewController = segue.destination as? TransactionCreationViewController else {
      return
    }
    
    creationViewController.transactionToEdit = selectedItem
    creationViewController.onCompose = { item in
      item.save()
    }
 
  }
}

extension TransactionListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    print(dateSections.count)
    return dateSections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dateSections[section].items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemTableViewCell
    let item = dateSections[indexPath.section].items[indexPath.row]
    cell.descriptionLabel.text = item.description
    cell.expenseLabel.text = expenseFormatter.string(from: NSNumber(value: item.expense))
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return dates[section]
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      items.removeAll(where: {item in item.id == dateSections[indexPath.section].items[indexPath.row].id})
      Item.save(items)
      getItems()
    }
  }
}
