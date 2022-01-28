//
//  DateTimeViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 4.10.2021.
//

import UIKit

protocol DateTimeViewControllerDelegate: AnyObject {
    func dateTimeViewController (_ vc: DateTimeViewController, time:String)
}

class DateTimeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    
    weak var delegate: DateTimeViewControllerDelegate?
    
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
        // Do any additional setup after loading the view.
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker)
    {
        print(sender.date)
    }
    

    @IBAction func ContinueButtonAction(_ sender: Any) {
        delegate?.dateTimeViewController(self, time: textField.text!)
        if changingTime == false
        {
            let PostTripViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripVC") as! PostTripViewController
                present(PostTripViewController, animated: true, completion: nil)
        }
        else
        {
            let PostFinalViewController = storyboard?.instantiateViewController(withIdentifier: "PostFinalVC") as! PostFinalViewController
            present(PostFinalViewController, animated: true, completion: nil)
        }
    }
    
}
