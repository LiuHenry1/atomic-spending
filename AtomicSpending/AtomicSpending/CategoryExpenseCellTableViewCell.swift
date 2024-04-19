//
//  CategoryExpenseCellTableViewCell.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/17/24.
//

import UIKit

class CategoryExpenseCell: UITableViewCell {

  @IBOutlet weak var category: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
