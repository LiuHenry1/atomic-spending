//
//  ItemTableViewCell.swift
//  AtomicSpending
//
//  Created by Henry Liu on 4/19/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var expenseLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
