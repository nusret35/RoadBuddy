//
//  SearchTimeViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 11.02.2022.
//
import UIKit

class SearchTimeViewController: UIViewController{
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    @objc func timePickerValueChanged(sender: UIDatePicker)
    {
        UserSearchTripRequest.time = myDateFormat.dateToString(sender.date)
        print(UserSearchTripRequest.time)
    }
    
    @IBAction func timeButtonAction(_ sender: Any)
    {
        
    }
    
    
    @IBAction func timePickerChangedValue(_ sender: UIDatePicker)
    {
        UserSearchTripRequest.time = myDateFormat.dateToString(sender.date)
        print(UserSearchTripRequest.time)
    }
    
}
