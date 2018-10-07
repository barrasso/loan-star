//
//  CreateViewController.swift
//  LoanStar
//
//  Created by mbarrass on 10/6/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit
import SwiftForms
import PopupDialog

class CreateViewController: FormViewController {

    let timePickerOptions = ["Day(s)", "Week(s)", "Month(s)", "Year(s)"] as [AnyObject]
    let tokenPickerOptions = ["WETH", "ETH", "DAI"] as [AnyObject]
    
    struct Static {
        static let loanTag = "loan"
        static let termTag = "term"
        static let interestTag = "interest"
        static let collateralTag = "collateral"
        static let termPicker = "termPicker"
        static let loanPicker = "loanPicker"
        static let collateralPicker = "collateralPicker"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New Loan"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(CreateViewController.submit(_:)))
    }
    
    // MARK: Actions
    
    @objc func submit(_: UIBarButtonItem!) {
        let message = self.form.formValues()
        showConfirmationDialog(message: message)
    }
    
    // MARK: Private interface
    
    fileprivate func loadForm() {
        
        let form = FormDescriptor(title: "Create Loan")
        
        let section1 = FormSectionDescriptor(headerTitle: "Loan", footerTitle: nil)
        
        var row = FormRowDescriptor(tag: Static.loanTag, type: .phone, title: "Amount")
        row.configuration.cell.appearance = ["textField.placeholder" : "0" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section1.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.loanPicker, type: .picker, title: "Token")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = tokenPickerOptions
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        row.value = tokenPickerOptions[0] as AnyObject
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section1.rows.append(row)
        
        let section2 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.termTag, type: .phone, title: "Term")
        row.configuration.cell.appearance = ["textField.placeholder" : "0" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section2.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.termPicker, type: .picker, title: "Period")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = timePickerOptions
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        row.value = timePickerOptions[0] as AnyObject
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section2.rows.append(row)
        
        let section3 = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        row = FormRowDescriptor(tag: Static.interestTag, type: .phone, title: "Interest (%)")
        row.configuration.cell.appearance = ["textField.placeholder" : "0" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section3.rows.append(row)
        
        let section4 = FormSectionDescriptor(headerTitle: "Collateral", footerTitle: "LTV 0.00%")
        
        row = FormRowDescriptor(tag: Static.collateralTag, type: .phone, title: "Amount")
        row.configuration.cell.appearance = ["textField.placeholder" : "0" as AnyObject, "textField.textAlignment" : NSTextAlignment.right.rawValue as AnyObject]
        section4.rows.append(row)
        
        row = FormRowDescriptor(tag: Static.collateralPicker, type: .picker, title: "Token")
        row.configuration.cell.showsInputToolbar = true
        row.configuration.selection.options = tokenPickerOptions
        row.configuration.selection.optionTitleClosure = { value in
            guard let option = value as? String else { return "" }
            return option
        }
        row.value = tokenPickerOptions[0] as AnyObject
        row.configuration.cell.appearance = [
            "valueLabel.accessibilityIdentifier": "PickerTextFied" as AnyObject]
        section4.rows.append(row)

        form.sections = [section1, section2, section3, section4]
        
        self.form = form
    }
    
    // MARK: Helper Functions
    
    func showConfirmationDialog(animated: Bool = true, message: [String:Any]) {
        let jsonMsg = JSON(message)
        
        // Prepare the popup assets
        let title = "You created a new loan"
        let message = "Amount: \(jsonMsg["loanTag"]) \(jsonMsg["loanPicker"])\nTerm: \(jsonMsg["termTag"]) \(jsonMsg["termPicker"])\n Interest: \(jsonMsg["interestTag"]) %\n Collateral: \(jsonMsg["collateralTag"]) \(jsonMsg["collateralPicker"])"
        let image = UIImage(named: "blue-star")
        
        // Create the dialog
        let popup = PopupDialog(title: title, message: message, image: image, preferredWidth: 580)
        
        // Create second button
        let buttonThree = DefaultButton(title: "OK") { [weak popup] in
            popup?.shake()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonThree])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
}
