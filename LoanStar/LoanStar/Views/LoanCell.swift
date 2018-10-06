//
//  LoanCell.swift
//  LoanStar
//
//  Created by mbarrass on 10/6/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit

class LoanCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var loan: Loan? {
        didSet {
            // set params
            amountLabel.text = loan?.amount
            statusLabel.text = loan?.category
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
