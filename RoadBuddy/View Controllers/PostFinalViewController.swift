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
    
    var fullname = ""
    
    var username = ""
    
    var uid = ""
    
    var tripIsSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        FromButton.setTitle(fromLoc, for: .normal)
        ToButton.setTitle(toLoc, for: .normal)
        TimeButton.setTitle(timeString, for: .normal)
        Passengers.setTitle(String(passengerNumber), for: .normal)
        Price.setTitle(priceString, for: .normal)
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        let docRef = db.collection("users").document(userID)
        docRef.getDocument{ snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let firstname = data["firstname"] as? String else{
                return
            }
            guard let lastname = data["lastname"] as? String else{
                return
            }
            guard let userName = data["username"] as? String else{
                return
            }
            guard let UID = data["uid"] as? String else{
                return
            }
            guard let tis = data["TripIsSet"] as? Bool else{
                return
            }
            self.fullname = firstname + " " + lastname
            self.username = userName
            self.uid = UID
            self.tripIsSet = tis
        }
        
    }
    
    
    //direk global vardan yap bu olacak gibi değil

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
        let post = ["fullname": fullname,
                    "uid": uid,
                    "from": fromLoc,
                     "to":   toLoc,
                    "time": timeString,
                    "number of passengers": passengerNumber,
                    "price": priceString,
                    "fromCoordinateLatitude": ptFromLocation.coordinate.latitude,
                    "fromCoordinateLongitude": ptFromLocation.coordinate.longitude,
                    "toCoordinateLatitude": ptToLocation.coordinate.latitude,
                    "toCoordinateLongitude": ptToLocation.coordinate.longitude
                    ] as [String:Any]
            ref?.child("Trips").child(uid).setValue(post)
            db.collection("users").document(uid).updateData(["TripIsSet":true])
            let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            mainTabController.selectedViewController = mainTabController.viewControllers?[2]
            present(mainTabController, animated: true, completion: nil)
    }
    
}

