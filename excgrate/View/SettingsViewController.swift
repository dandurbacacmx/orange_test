//
//  SettingsViewController.swift
//  excgrate
//
//  Created by Dan Durbaca on 08/03/2020.
//  Copyright © 2020 Dan Durbaca. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
        
    @IBOutlet weak var baseCurrencyPicker : UIPickerView!
    @IBOutlet weak var refreshIntervalPicker : UIPickerView!

    let intervalOptions = ["3","5","15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Settings"
        self.bindViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.baseCurrencyPicker.reloadAllComponents()
        if let i = CurrencyService.lastCallData.rates.firstIndex(where: { $0.currencyIso ==  CurrencyService.baseCurrency}) {
            self.baseCurrencyPicker.selectRow(i, inComponent: 0, animated: false)
        }
        self.refreshIntervalPicker.reloadAllComponents()
        if let i = intervalOptions.firstIndex(where: { $0 == CurrencyService.baseCurrency+""}) {
            self.refreshIntervalPicker.selectRow(i, inComponent: 0, animated: false)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
        
    private func bindViews() {
    
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == self.baseCurrencyPicker) {
            return CurrencyService.lastCallData.rates.count
        }
        return intervalOptions.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == self.baseCurrencyPicker) {
            return CurrencyService.lastCallData.rates[row].currencyIso
        }
        return intervalOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        if(pickerView == self.baseCurrencyPicker) {
            CurrencyService.baseCurrency = CurrencyService.lastCallData.rates[row].currencyIso
        } else {
            CurrencyService.refreshInterval = Double(intervalOptions[row])!
        }
    }
}
