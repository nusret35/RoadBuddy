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

protocol PostFinalViewControllerDelegate: AnyObject {
    func postFinalViewController(_ vc: PostFinalViewController)
}

class PostFinalViewController: UIViewController, PostTripToViewControllerDelegate, PostTripFromViewControllerDelegate {
    
    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var TimeButton: UIButton!
    
    @IBOutlet weak var Passengers: UIButton!
    
    @IBOutlet weak var Price: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    var ref:DatabaseReference?
    
    let db = Firestore.firestore()
    
    weak var delegate: PostFinalViewControllerDelegate?
    
    var fullname = ""
    
    var username = ""
    
    var uid = ""
    
    var tripIsSet = false
    
    var fromCoordinateLatitude: Double = 1.3234234234
    
    var fromCoodinateLongitude: Double = 1.234234234
    
    var toCoordinateLatitude: Double = 1.456456
    
    var toCoordinateLongitude: Double = 1.567858
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let PostTripFromViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripFromVC") as! PostTripFromViewController
        let PostTripToViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripToVC") as! PostTripToViewController
        PostTripToViewController.delegate = self
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
    func postTripToViewControlle(_ vc: PostTripToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String)
    {
        print("coordinates.to: " + String(coordinates.latitude))
        self.toCoordinateLatitude = coordinates.latitude
        self.toCoordinateLongitude = coordinates.longitude
    }
    
    func postTripFromViewController(_ vc: PostTripFromViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String) {
        self.fromCoordinateLatitude = coordinates.latitude
        self.fromCoodinateLongitude = coordinates.longitude
    }

    @IBAction func FromButtonAction(_ sender: Any) {
        changingLoc = true
        let PostTripFromViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripFromVC") as! PostTripFromViewController
        present(PostTripFromViewController, animated: true, completion: nil)
    }
    
    @IBAction func ToButtonAction(_ sender: Any)
    {
        changingLoc = true
        let PostTripToViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripToVC") as! PostTripToViewController
        present(PostTripToViewController, animated: true, completion: nil)
    }
    
    @IBAction func TimeButtonAction(_ sender: Any)
    {
        changingTime = true
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
                    "fromCoordinateLatitude": ptFromLatitude,
                    "fromCoordinateLongitude": ptFromLongitude,
                    "toCoordinateLatitude": ptToLatitude,
                    "toCoordinateLongitude": ptToLongitude] as [String:Any]
            ref?.child("Trips").child(uid).setValue(post)
            db.collection("users").document(uid).updateData(["TripIsSet":true])
            let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
            mainTabController.selectedViewController = mainTabController.viewControllers?[2]
            print("fromcoordinatelongtitude: " + String(fromCoordinateLatitude))
            present(mainTabController, animated: true, completion: nil)
    }
    
}

