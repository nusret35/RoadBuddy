//
//  FromWhereToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 24.09.2021.
//

import UIKit
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import MapKit

var SearchFrom = "From..."

var SearchTo = "To..."

var SearchTime = "Choose time..."

class FromWhereToViewController: UIViewController{

    let mapsStoryboard = UIStoryboard(name: "Maps", bundle: nil)
    
    var request = [String:Any]()
    
    let registrationStoryboard = UIStoryboard(name:"Registration",bundle:nil)
    
    var sortedTrips = [DriverData]()
    
    @IBOutlet weak var WhereToButton: UIButton! //From button
    
    @IBOutlet weak var WhereToLabel: UILabel!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        errorLabel.alpha = 0
        WhereToButton.setTitle(SearchFrom, for: .normal)
        ToButton.setTitle(SearchTo, for: .normal)
        timeButton.setTitle(SearchTime, for: .normal)
    }
    //FUNCTIONS
    
    func validateFields() ->String? {
        if WhereToButton.titleLabel!.text! == "From..." || ToButton.titleLabel!.text! == "To..."
        {
            return "Please choose a location"
        }
        return nil
    }
    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    

    
    //BUTTON ACTIONS
    
    @IBAction func FromButtonAction(_ sender: Any) {  //From button action        
        let FromViewController = mapsStoryboard.instantiateViewController(withIdentifier:  "FromVC") as! FromViewController
 
        navigationController?.pushViewController(FromViewController, animated: true)
    }
    
    
    @IBAction func ToButtonAction(_ sender: Any) {
        let ToViewController = mapsStoryboard.instantiateViewController(withIdentifier:  "ToVC") as! ToViewController
 
        navigationController?.pushViewController(ToViewController, animated: true)
    
    }
    
    @IBAction func timebuttonAction(_ sender: Any)
    {
        
    }
    
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        let error = validateFields()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            self.request = ["fullname": CurrentUser.Fullname, "uid": CurrentUser.UID, "time": TimeString,"number of passengers": PassengerNumber , "fromLocationName": SearchFrom, "toLocationName": SearchTo, "fromCoordinateLat": SearchFromLocation.coordinate.latitude,"fromCoordinateLong": SearchFromLocation.coordinate.longitude, "toCoordinateLat": SearchToLocation.coordinate.latitude, "toCoordinateLong": SearchToLocation.coordinate.longitude ] as [String : Any]
            
        }
        
        
    }
    
    func matchRequest()
    {
        var trips:[DriverData] = []

        storageManager.databaseRef.child("Trips")
        .observeSingleEvent(of: .value, with: { (snapshot)  in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let name = res["fullname"] as! String
                print(name)
                let from = res["from"] as! String
                let to = res["to"] as! String
                let price = res["price"] as! String
                let time = res["time"] as! String
                let numberOfPassengers = res["number of passengers"] as! Int
                let fromLat = res["fromCoordinateLatitude"] as! Double
                let fromLong = res["fromCoordinateLongitude"] as! Double
                let toLat = res["toCoordinateLatitude"] as! Double
                let toLong = res["toCoordinateLongitude"] as! Double
                let dUID = res["uid"] as! String
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                
                let fromDistance = SearchFromLocation.distance(from: dataFromLocation) / 1000
                guard let currentUserID = Auth.auth().currentUser?.uid else
                {
                    print("user not found")
                    return
                }
                if (currentUserID != dUID)
                {
                    if (fromDistance <= 8)
                    {
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = SearchToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 8)
                        {
                            if (PassengerNumber <= numberOfPassengers)
                            {
                                let data = DriverData(driverName: name, fromLocation: from, toLocation: to, price: price, time: time, numberOfPassengers: numberOfPassengers,uid:dUID)
                                trips.append(data)
                                print(trips[0].driverName)
                            }
                        }
                    }
                }
            }
            
        })
        
    }
}
    
    




