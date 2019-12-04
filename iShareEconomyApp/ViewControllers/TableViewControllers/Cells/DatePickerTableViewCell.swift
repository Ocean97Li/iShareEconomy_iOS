//
//  DatePickerTableViewCell.swift
//  iShareEconomyApp
//
//  Created by Hu Ocean Li on 03/12/2019.
//  Copyright © 2019 Hu Ocean Li. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell {

    @IBOutlet var inputTextfield: UITextField!
    
    var emits: Bool = false
        
    var minDate: Date? {
        didSet {
            if date == nil || date! < minDate! {
                date = minDate
            }
            setDatePicker()
        }
    }
    
    var date: Date? {
        didSet {
            setDatePicker()
        }
    }
    
    var maxDaysInAdvanceNumber = 14
    
    override func awakeFromNib() {
        super.awakeFromNib()
        date = minDate ?? Date()
        setDatePicker()
    }
    
    private func setDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = minDate ?? Date()
        datePicker.maximumDate = Date().adding(.day, maxDaysInAdvanceNumber)
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        datePicker.date = date!
        inputTextfield.inputView = datePicker
        inputTextfield.text = date!.toShortString()
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        date = datePicker.date
        inputTextfield.text = datePicker.date.toShortString()
        if emits {
            CellCoordinator.shared.datePickerDate.onNext(date!)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
