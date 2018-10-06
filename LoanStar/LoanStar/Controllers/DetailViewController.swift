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

    var detailLoan: Loan? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailLoan = detailLoan {
            if let detailDescriptionLabel = detailDescriptionLabel {
                detailDescriptionLabel.text = detailLoan.name
                title = detailLoan.category
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}
