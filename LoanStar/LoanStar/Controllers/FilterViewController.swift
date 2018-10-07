//
//  FilterViewController.swift
//  LoanStar
//
//  Created by mbarrass on 10/6/18.
//  Copyright © 2018 ethsociety. All rights reserved.
//

import UIKit
import SwiftForms

class FilterViewController: FormViewController {
    let pickerOptions = ["DAI", "ETH", "WETH"] as [AnyObject]
    
    struct Static {
        static let termSlider = "termSlider"
        static let amountSlider = "amountSlider"
        static let interestSlider = "interestSlider"
        static let principlePicker = "principlePicker"
        static let collateralPicker = "collateralPicker"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // load saved filter config
        if let config = UserDefaults.standard.dictionary(forKey: "FilterConfig") {
            self.loadForm(config: config)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Advanced Search"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(FilterViewController.filter(_:)))
    }
    
    // MARK: Actions
    
    @objc func filter(_: UIBarButtonItem!) {
        let config = self.form.formValues()
        UserDefaults.standard.set(config, forKey: "FilterConfig")
        _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private interface
    
    fileprivate func loadForm(config: [String : Any]) {
        if !config.isEmpty {
            // USED SAVED FILTER CONFIGURATION
            let json = JSON(config)
            let form = FormDescriptor(title: "Advanced Search")
            
            let section1 = FormSectionDescriptor(headerTitle: "Saved Config", footerTitle: nil)
            
            var row = FormRowDescriptor(tag: Static.termSlider, type: .slider, title: "Term     ")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = json["termSlider"].doubleValue as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.amountSlider, type: .slider, title: "Amount")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = json["amountSlider"].doubleValue as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.interestSlider, type: .slider, title: "Interest ")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = json["interestSlider"].doubleValue as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            let section2 = FormSectionDescriptor(headerTitle: "Addresses", footerTitle: nil)
            
            row = FormRowDescriptor(tag: Static.principlePicker, type: .picker, title: "Principle Token")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = pickerOptions
            row.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            row.value = json["principlePicker"].stringValue as AnyObject
            row.configuration.cell.appearance = [
                "valueLabel.accessibilityIdentifier": "PickerTextField" as AnyObject]
            section2.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.collateralPicker, type: .picker, title: "Collateral Token")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = pickerOptions
            row.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            row.value = json["collateralPicker"].stringValue as AnyObject
            row.configuration.cell.appearance = [
                "valueLabel.accessibilityIdentifier": "PickerTextField" as AnyObject]
            section2.rows.append(row)

            form.sections = [section1, section2]
            self.form = form
        } else {
            
            // GO WITH DEFAULT CONFIGURATION
            let form = FormDescriptor(title: "Advanced Search")
            
            let section1 = FormSectionDescriptor(headerTitle: "Default Config", footerTitle: nil)
            
            var row = FormRowDescriptor(tag: Static.termSlider, type: .slider, title: "Term     ")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = 50.0 as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.amountSlider, type: .slider, title: "Amount")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = 50.0 as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.interestSlider, type: .slider, title: "Interest ")
            row.configuration.stepper.maximumValue = 100.0
            row.configuration.stepper.minimumValue = 0.0
            row.configuration.stepper.steps = 1.0
            row.value = 50.0 as AnyObject
            row.configuration.cell.appearance = ["titleLabel.textColor": UIColor.black,
                                                 "sliderView.tintColor": UIColor.mariner]
            section1.rows.append(row)
            
            let section2 = FormSectionDescriptor(headerTitle: "Addresses", footerTitle: nil)
            
            row = FormRowDescriptor(tag: Static.principlePicker, type: .picker, title: "Principle Token")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = pickerOptions
            row.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            row.value = pickerOptions[0] as AnyObject
            row.configuration.cell.appearance = [
                "valueLabel.accessibilityIdentifier": "PickerTextField" as AnyObject]
            section2.rows.append(row)
            
            row = FormRowDescriptor(tag: Static.collateralPicker, type: .picker, title: "Collateral Token")
            row.configuration.cell.showsInputToolbar = true
            row.configuration.selection.options = pickerOptions
            row.configuration.selection.optionTitleClosure = { value in
                guard let option = value as? String else { return "" }
                return option
            }
            row.value = pickerOptions[2] as AnyObject
            row.configuration.cell.appearance = [
                "valueLabel.accessibilityIdentifier": "PickerTextField" as AnyObject]
            section2.rows.append(row)
            
            form.sections = [section1, section2]
            self.form = form
        }
    }
}
