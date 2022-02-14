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
        let moment = Date()
        timePicker.minimumDate = moment
        UserSearchTripRequest.time = myDateFormat.dateToString(moment)
    }
    
    @IBAction func timeButtonAction(_ sender: Any)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SearchPassengerVC") as! SearchPassengerViewController
        vc.title = "How many people are you with?"
        vc.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func timePickerChangedValue(_ sender: UIDatePicker)
    {
        UserSearchTripRequest.time = myDateFormat.dateToString(sender.date)
        print(UserSearchTripRequest.time)
    }
    
}
