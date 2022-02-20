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
    
    var settingForTaxi = Bool()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let moment = Date()
        timePicker.minimumDate = moment
        timePicker.locale = Locale(identifier: "en_US_POSIX".localized())
        
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
            vc.settingForPost = false
            vc.settingForSearch = true
            pushToPassengerVC(vc)
        }
        else if settingForTaxi == true
        {
            sendTaxiRequest()
        }
    }
    
    
    @IBAction func timePickerChangedValue(_ sender: UIDatePicker)
    {
        settingType(sender.date)
    }
    
    func settingType(_ date:Date)
    {
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
        else if settingForTaxi == true
        {
            UserTaxiTripRequest.time = stringDate
        }
    }
    
    func sendTaxiRequest()
    {
        let request = ["fullname":UserTaxiTripRequest.fullname,
                       "uid":UserTaxiTripRequest.uid,
                       "time":UserTaxiTripRequest.time,
                       "fromLocationName":UserTaxiTripRequest.fromLocationName,
                       "fromLocationLat":UserTaxiTripRequest.fromCoordinateLat,
                       "fromLocationLong":UserTaxiTripRequest.fromCoordinateLong,
                       "toLocationName":UserTaxiTripRequest.toLocationName,
                       "toLocationLat":UserTaxiTripRequest.toCoordinateLat,
                       "toLocationLong":UserTaxiTripRequest.toCoordinateLong] as [String:Any]
        storageManager.ref.child("Taxi_Requests").child(CurrentUser.UID).setValue(request)
        let alert = UIAlertController(title: "We have received your request".localized(), message: "We will look for your match and notify you when we found one.".localized(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Okay".localized(),style: .default, handler:{( action) in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert,animated: true,completion: nil)
        
    }
    
    func pushToPassengerVC(_ vc:UIViewController)
    {
        vc.title = "How many people are you with?".localized()
        vc.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        navigationController?.pushViewController(vc, animated: true)
    }
}
