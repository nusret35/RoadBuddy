//
//  SearchTimeViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 11.02.2022.
//
import UIKit
import FirebaseDatabase

class SearchTimeViewController: UIViewController{
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var settingForSearch = Bool()
    
    var settingForPost = Bool()
    
    var settingForTaxi = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let moment = Date()
        timePicker.minimumDate = moment
        //timePicker.locale = Locale(identifier: "en_US_POSIX".localized())
        
    }
    
   @IBAction func timeButtonAction(_ sender: Any)
    {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "SearchPassengerVC") as! SearchPassengerViewController
         if settingForPost == true
        {
            vc.settingForPost = true
            vc.settingForSearch = false
            pushToPassengerVC(vc)
         }
        else if settingForSearch == true
        {
            checkIfThereIsAnotherRequestWithSameTime { error in
                if error == nil
                {
                    vc.settingForPost = false
                    vc.settingForSearch = true
                    self.pushToPassengerVC(vc)
                }
                else
                {
                    let alert = UIAlertController(title: "Choose another time", message: "You already have a request for the selected time.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert,animated:true)
                }
            }
        }
        else if settingForTaxi == true
        {
            let taxiResultViewController = TaxiTripsMatchViewController()
            taxiResultViewController.title = "Searching for taxi trips"
            navigationController?.pushViewController(taxiResultViewController, animated: true)
        }
    }
    
    
    @IBAction func timePickerChangedValue(_ sender: UIDatePicker)
    {
        settingType(sender.date)
    }
    
    func settingType(_ date:Date)
    {
        let stringDate = myDateFormat.dateToString(date)
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
        else if settingForTaxi == true
        {
            UserTaxiTripRequest.time = stringDate
            print(UserTaxiTripRequest.time)
        }
    }
    
    
    func pushToPassengerVC(_ vc:UIViewController)
    {
        vc.title = "How many people are you with?".localized()
        vc.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func checkIfThereIsAnotherRequestWithSameTime(completion: @escaping (String?) -> ())
    {
        var error:String? = nil
        storageManager.ref.child("Search_Requests").child(CurrentUser.UID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let time = res["time"] as! String
                if time == UserSearchTripRequest.time
                {
                    error = "You already have a request for the same time"
                }
            }
            completion(error)
        })
    }
}
