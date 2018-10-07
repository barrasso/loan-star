//
//  DetailViewController.swift
//  LoanStar
//
//  Created by mbarrass on 10/5/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    
    @IBOutlet weak var loanValueLabel: UILabel!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    
    @IBOutlet weak var termValueLabel: UILabel!
    @IBOutlet weak var termTypeLabel: UILabel!
    
    @IBOutlet weak var interestValueLabel: UILabel!
    
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ] as [NSAttributedString.Key : Any]
    
    var detailLoan: Loan? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailLoan = detailLoan {
            if let detailDescriptionLabel = detailDescriptionLabel {
                detailDescriptionLabel.text = "Loan ID: \(detailLoan.id)"
                createdLabel.text = "Created at\n\(detailLoan.created)"
                expiresLabel.text = "Expires on\n\(detailLoan.expires)"
                loanValueLabel.text = "\(detailLoan.amount)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Loan Details"
        configureView()
    }
}
