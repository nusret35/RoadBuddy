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
    
    var settingForSearch = Bool()
    
    var settingForPost = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let moment = Date()
        timePicker.minimumDate = moment
        settingType(moment)
    }
    
    @IBAction func timeButtonAction(_ sender: Any)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SearchPassengerVC") as! SearchPassengerViewController
        vc.settingForPost = true
        vc.settingForSearch = false
        vc.title = "How many people are you with?".localized()
        vc.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func timePickerChangedValue(_ sender: UIDatePicker)
    {
        settingType(sender.date)
    }
    
    func settingType(_ date:Date)
    {
        if settingForSearch == true
        {
            UserSearchTripRequest.time = myDateFormat.dateToString(date)
            print(UserSearchTripRequest.time)
        }
        else if settingForPost == true
        {
            CurrentUserTripPost.time = myDateFormat.dateToString(date)
            print(CurrentUserTripPost.time)
        }
    }
    
}
