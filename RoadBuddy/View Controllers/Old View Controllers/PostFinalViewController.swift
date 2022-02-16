//
//  PostFinalViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 12.10.2021.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage


class PostFinalViewController: UIViewController
{
    
    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var TimeButton: UIButton!
    
    @IBOutlet weak var Passengers: UIButton!
    
    @IBOutlet weak var Price: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    let mapsStoryboard = UIStoryboard(name: "Maps", bundle: nil)
    
    var ref:DatabaseReference?
    
    let db = Firestore.firestore()
    
    var tripIsSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        FromButton.setTitle(FromLoc, for: .normal)
        ToButton.setTitle(ToLoc, for: .normal)
        TimeButton.setTitle(TimeString, for: .normal)
        Passengers.setTitle(String(PassengerNumber), for: .normal)
        Price.setTitle(PriceString, for: .normal)
    }


    @IBAction func FromButtonAction(_ sender: Any) {
        let PostTripFromViewController = mapsStoryboard.instantiateViewController(withIdentifier: "PostTripFromVC") as! PostTripFromViewController
        present(PostTripFromViewController, animated: true, completion: nil)
    }
    
    @IBAction func ToButtonAction(_ sender: Any)
    {
        let PostTripToViewController = mapsStoryboard.instantiateViewController(withIdentifier: "PostTripToVC") as! PostTripToViewController
        present(PostTripToViewController, animated: true, completion: nil)
    }
    
    @IBAction func TimeButtonAction(_ sender: Any)
    {
        
        let DateTimeViewController = storyboard?.instantiateViewController(withIdentifier: "DateTimeVC") as! DateTimeViewController
        present(DateTimeViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func PassengerButtonAction(_ sender: Any)
    {
        let PassengersPriceViewController = storyboard?.instantiateViewController(withIdentifier: "PassengerPriceVC") as! PassengerPriceViewController
        present(PassengersPriceViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func PriceButtonAction(_ sender: Any)
    {
        let PassengersPriceViewController = storyboard?.instantiateViewController(withIdentifier: "PassengerPriceVC") as! PassengerPriceViewController
        present(PassengersPriceViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func ContinueButtonAction(_ sender: Any)
    {
        //validate the fields
        let post = ["fullname": CurrentUser.Fullname,
                    "uid": CurrentUser.UID,
                    "from": FromLoc,
                     "to":   ToLoc,
                    "time": TimeString,
                    "number of passengers": PassengerNumber,
                    "price": PriceString,
                    "fromCoordinateLatitude": PtFromLocation.coordinate.latitude,
                    "fromCoordinateLongitude": PtFromLocation.coordinate.longitude,
                    "toCoordinateLatitude": PtToLocation.coordinate.latitude,
                    "toCoordinateLongitude": PtToLocation.coordinate.longitude
                    ] as [String:Any]
        ref?.child("Trips").child(CurrentUser.UID).setValue(post)
        db.collection("users").document(CurrentUser.UID).updateData(["TripIsSet":true])
            let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            mainTabController.selectedViewController = mainTabController.viewControllers?[2]
            present(mainTabController, animated: true, completion: nil)
    }
    
}

