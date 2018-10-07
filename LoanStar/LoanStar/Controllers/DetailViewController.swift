//
//  DetailViewController.swift
//  LoanStar
//
//  Created by mbarrass on 10/5/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit
import web3swift
import PopupDialog

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var expiresLabel: UILabel!
    
    @IBOutlet weak var loanValueLabel: UILabel!
    @IBOutlet weak var tokenTypeLabel: UILabel!
    
    @IBOutlet weak var termValueLabel: UILabel!
    @IBOutlet weak var termTypeLabel: UILabel!
    
    @IBOutlet weak var interestValueLabel: UILabel!
    
    @IBOutlet weak var fillRequestButton: UIButton!
    
    let strokeTextAttributes = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)
        ] as [NSAttributedString.Key : Any]
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var ks: EthereumKeystoreV3?
    let web3Rinkeby = Web3.InfuraRinkebyWeb3()
    let jsonString = "[{\"constant\":true,\"inputs\":[],\"name\":\"name\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"decimals\",\"outputs\":[{\"name\":\"\",\"type\":\"uint8\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"version\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"symbol\",\"outputs\":[{\"name\":\"\",\"type\":\"string\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint256\"},{\"name\":\"_extraData\",\"type\":\"bytes\"}],\"name\":\"approveAndCall\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint256\"}],\"payable\":false,\"type\":\"function\"},{\"inputs\":[{\"name\":\"_initialAmount\",\"type\":\"uint256\"},{\"name\":\"_tokenName\",\"type\":\"string\"},{\"name\":\"_decimalUnits\",\"type\":\"uint8\"},{\"name\":\"_tokenSymbol\",\"type\":\"string\"}],\"type\":\"constructor\"},{\"payable\":false,\"type\":\"fallback\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint256\"}],\"name\":\"Approval\",\"type\":\"event\"},]"

    
    // MARK: Lifecycle
    
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
        if !checkWallet() {
            initEthereumKeystore()
        }
    }
    
    // MARK: - ETH Functions
    
    func fill(loan: Loan) {
     
        // perform fillDebtOrder tx
        let keystoreManager = KeystoreManager.managerForPath(self.userDir + "/keystore")
        let constractAddress = EthereumAddress("0x45245bc59219eeaaf6cd3f382e078a461ff9de7b")!
        
        DispatchQueue.global().async{
            let gasPriceResult = self.web3Rinkeby.eth.getGasPrice()
            guard case .success(let gasPrice) = gasPriceResult else {return}
            var options = Web3Options.defaultOptions()
            options.gasPrice = gasPrice
            options.from = self.ks?.addresses?.first!
            let parameters = [] as [AnyObject]
            
            self.web3Rinkeby.addKeystoreManager(keystoreManager)
            let contract = self.web3Rinkeby.contract(self.jsonString, at: constractAddress, abiVersion: 2)!
            let intermediate = contract.method("name", parameters:parameters,  options: options)
            guard let tokenNameRes = intermediate?.call(options: options) else {return}
            guard case .success(let result) = tokenNameRes else {return}
            DispatchQueue.main.async {
                print("Result = " + (result["0"] as! String))
            }
        }
        
        // fill confirmation
        activityIndicator.removeFromSuperview()
        fillRequestButton.setTitle("Fill Loan Request", for: .normal)
        showConfirmationDialog(loan: loan)
    }
    
    @IBAction func fillButtonTapped(_ sender: Any) {
        fillRequestButton.setTitle("", for: .normal)
        view.addSubview(activityIndicator)
        activityIndicator.frame = fillRequestButton.bounds
        activityIndicator.center = fillRequestButton.center
        activityIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.fill(loan: self.detailLoan!)
        }
    }
    
    func initEthereumKeystore() {
        let keystoreManager = KeystoreManager.managerForPath(self.userDir + "/keystore")
        if (keystoreManager?.addresses?.count == 0) {
            ks = try! EthereumKeystoreV3(password: UUID().uuidString)
            let keydata = try! JSONEncoder().encode(ks!.keystoreParams)
            FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
        } else {
            ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as? EthereumKeystoreV3
        }
        guard let sender = ks?.addresses?.first else {return}
        print(sender)
    }
    
    func checkWallet() -> Bool {
        let keystoreManager = KeystoreManager.managerForPath(self.userDir + "/keystore")
        if (keystoreManager?.addresses?.count != 0) {
            ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as? EthereumKeystoreV3
            return true
        } else {
            return false
        }
    }
    
    // MARK: Helper Functions
    
    func showConfirmationDialog(animated: Bool = true, loan: Loan) {
        
        let title = "You filled a loan!"
        let message = "Loan details: \(loan.amount) WETH\nExpires on: \(loan.expires)\n\nLoan ID: \(loan.id)"
        let image = UIImage(named: "blue-star")
        
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        let button = DefaultButton(title: "OK") { [weak popup] in
            popup?.shake()
        }
        popup.addButtons([button])
        
        self.present(popup, animated: animated, completion: nil)
    }
}
