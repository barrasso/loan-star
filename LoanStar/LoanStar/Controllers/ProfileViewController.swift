//
//  ProfileViewController.swift
//  LoanStar
//
//  Created by mbarrass on 10/5/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit
import web3swift

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var ks: EthereumKeystoreV3?
    var walletAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if checkWallet() {
            if let usernameLabel = usernameLabel {
                usernameLabel.text = "@username\n\(walletAddress ?? "")"
            }
        }
    }
    
    func checkWallet() -> Bool {
        let keystoreManager = KeystoreManager.managerForPath(self.userDir + "/keystore")
        if (keystoreManager?.addresses?.count != 0) {
            ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as? EthereumKeystoreV3
            self.walletAddress = ks?.addresses?.first?.address
            return true
        } else {
            return false
        }
    }
}
