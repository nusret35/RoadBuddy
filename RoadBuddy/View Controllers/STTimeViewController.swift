//
//  STTimeViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 29.11.2021.
//

import UIKit

protocol STTimeViewControllerDelegate: AnyObject
{
    func stTimeViewController(_ vc:STTimeViewController, time:String)
}

class STTimeViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    weak var delegate: STTimeViewControllerDelegate?
    
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

    //bu niye calismiyo aq
    @IBAction func continueButtonAction(_ sender: Any) {
       
        delegate?.stTimeViewController(self, time: textField.text!)
        let TaxiTripSetViewController = storyboard?.instantiateViewController(withIdentifier: "TaxiTripSetVC") as! TaxiTripSetViewController
            present(TaxiTripSetViewController, animated: true, completion: nil)
    }

}
