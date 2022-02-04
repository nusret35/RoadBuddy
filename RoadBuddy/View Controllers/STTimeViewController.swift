//
//  STTimeViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 29.11.2021.
//

import UIKit


class STTimeViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    
    private lazy var dateTimePicker: DateTimePicker = {
       let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (dayDate,startDate) in
            let text = Date.buildTimeRangeString(dayDate: dayDate,startDate: startDate)
            self?.textField.text = text
        }
        return picker
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.inputView = dateTimePicker.inputView
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker)
    {
        print(sender.date)
    }

    @IBAction func continueButtonAction(_ sender: Any)
    {
        timeStringTaxi = textField.text ?? ""
        dismiss(animated: true, completion: nil)
    }

}
