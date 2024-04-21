//
//  CategoryExpenseCell.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/17/24.
//

import UIKit
import SwiftUI

class CategoryExpenseCell: UITableViewCell {
  
  
  @IBOutlet weak var categoryLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    

  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

