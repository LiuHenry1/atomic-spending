//
//  TransactionCreationViewController.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/20/24.
//

import UIKit

class TransactionCreationViewController: UIViewController {
  @IBOutlet weak var titleLabel: UINavigationItem!
  @IBOutlet weak var descriptionTextBox: UITextField!
  @IBOutlet weak var expenseTextBox: UITextField!
  @IBOutlet weak var categoryTextBox: UITextField!
  @IBOutlet weak var dropDown: UIPickerView!
  @IBOutlet weak var datePicker: UIDatePicker!
  var expense: Float = 0
  @IBOutlet weak var composeButton: UIButton!
  
  
  var transactionToEdit: Item? = nil
  var onCompose: ((Item) -> Void)? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    categoryTextBox.delegate = self
    dropDown.dataSource = self
    dropDown.delegate = self
    

    datePicker.contentHorizontalAlignment = .left
    if let item = transactionToEdit {
      descriptionTextBox.text = item.description
      categoryTextBox.text = item.category.rawValue
      expenseTextBox.text = String(item.expense).toCurrencyFormat()
      titleLabel.title = "Edit Transaction"
      datePicker.date = item.date
      composeButton.setTitle("Modify", for: .normal)
    }
  }
  
  
  @IBAction func expenseTextDidChange(_ sender: Any) {
    if let amountString = expenseTextBox.text?.currencyInputFormatting() {
      expenseTextBox.text = amountString
    }
  }

  
  @IBAction func didTapComposeButton(_ sender: Any) {
    var item: Item
    if var editItem = transactionToEdit {
      editItem.description = descriptionTextBox.text ?? "Unnamed"
      editItem.expense = expenseTextBox.text?.toDouble() ?? 0
      editItem.category = Category(rawValue: categoryTextBox.text!)!
      editItem.date = datePicker.date
      
      item = editItem
    } else {
      item = Item(category: Category(rawValue: categoryTextBox.text!)!, description: descriptionTextBox.text ?? "Unnamed", expense: expenseTextBox.text?.toDouble() ?? 0, date: datePicker.date)
    }
    
    onCompose?(item)
    navigationController?.popViewController(animated: true)
  }
}

extension TransactionCreationViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Category.allCases.count - 1
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    self.view.endEditing(true)
    return Category.allCases[row].rawValue
    
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    categoryTextBox.text = Category.allCases[row].rawValue
    dropDown.isHidden = true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if textField == categoryTextBox {
      dropDown.isHidden = false
      textField.endEditing(true)
    }
  }
  
}

extension String {
  func toCurrencyFormat() -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.currencySymbol = "$"
    formatter.minimumFractionDigits = 2
    
    return formatter.string(from: (self as NSString).doubleValue as NSNumber)!
  }
  func currencyInputFormatting() -> String {
    var number: NSNumber!
    let formatter = NumberFormatter()
    formatter.numberStyle = .currencyAccounting
    formatter.currencySymbol = "$"
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    
    var amt = self
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
       amt = regex.stringByReplacingMatches(in: amt, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
       
       let double = (amt as NSString).doubleValue
       number = NSNumber(value: (double / 100))
       
       // if first number is 0 or all numbers were deleted
       guard number != 0 as NSNumber else {
           return ""
       }
       
       return formatter.string(from: number)!
  }
  
  func toDouble() -> Double {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    let amt =  formatter.number(from: self)
    
    return amt?.doubleValue ?? 0}
}
