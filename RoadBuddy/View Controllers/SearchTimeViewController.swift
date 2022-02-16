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
        print(myDateFormat.dateToString(moment))
        print("tripPost.time: " + CurrentUserTripPost.time)
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
        print("inside settingType")
        let stringDate =  myDateFormat.dateToString(date)
        if settingForSearch == true
        {
            UserSearchTripRequest.time = stringDate
            print(UserSearchTripRequest.time)
        }
        else if settingForPost == true
        {
            print("inside settingForPost")
            CurrentUserTripPost.time = stringDate
            print(CurrentUserTripPost.time)
        }
    }
    
}
