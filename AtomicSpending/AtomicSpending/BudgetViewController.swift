//
//  BudgetViewController.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/21/24.
//

import UIKit

class BudgetViewController: UIViewController, UITextFieldDelegate {
  var budgets: [Category: Double] = [:]
  @IBOutlet weak var housingTextField: UITextField!
  @IBOutlet weak var utilitiesTextField: UITextField!
  @IBOutlet weak var foodTextField: UITextField!
  @IBOutlet weak var personalTextField: UITextField!
  @IBOutlet weak var insuranceTextField: UITextField!
  @IBOutlet weak var medicalTextField: UITextField!
  @IBOutlet weak var debtTextField: UITextField!
  
  var categoryBudgetTextFields: [Category: UITextField] = [:
  ]
  
  @IBAction func didTapSaveButton(_ sender: Any) {
    let defaults = UserDefaults.standard
    for (category, textField) in categoryBudgetTextFields {
      defaults.set(textField.text?.toDouble(), forKey: category.rawValue)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    getBudgets()
    categoryBudgetTextFields = [
      .housing: housingTextField,
      .utilies: utilitiesTextField,
      .food: foodTextField,
      .personal: personalTextField,
      .insurance: insuranceTextField,
      .medical: medicalTextField,
      .debtPayment: debtTextField
    ]
    
    loadBudgets()
    
    for (_, textField) in categoryBudgetTextFields {
      configureTextField(textField)
    }
    
  }
  
  func configureTextField(_ textField: UITextField) {
    textField.delegate = self
    textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
  }
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    if let amountString = textField.text?.currencyInputFormatting() {
      textField.text = amountString
    }
  }
  
  func loadBudgets() {
    for (category, budget) in budgets {
      categoryBudgetTextFields[category]?.text = String(budget).currencyInputFormatting()
    }
  }
  
    
  private func getBudgets() {
    let defaults = UserDefaults.standard
    
    
    var budgets: [Category: Double] = [:]
    for category in Category.allCases {
      let budget = defaults.double(forKey: category.rawValue)
      budgets[category] = budget
    }
    self.budgets = budgets;
  }
  
  
  

}
