//
//  SearchPassengerViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 13.02.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

class SearchPassengerViewController: UIViewController {

    var settingForSearch = Bool()
    
    var settingForPost = Bool()
    
    //let uid = Auth.auth().currentUser?.uid as! String
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var plusButton: UIButton!
        
    private var numberOfPassengers = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = String(numberOfPassengers)
        minusButton.tintColor = .secondaryLabel
        minusButton.setTitle("", for: .normal)
    }
    
    
    
    @IBAction func minusButtonAction(_ sender: Any)
    {
        if (numberOfPassengers != 1)
        {
            numberOfPassengers -= 1
            numberLabel.text = String(numberOfPassengers)
            if numberOfPassengers == 1
            {
                minusButton.tintColor = .secondaryLabel
            }
            else if numberOfPassengers == 3
            {
                plusButton.tintColor = .systemTeal
            }
        }
    }
    
    
    @IBAction func plusButtonAction(_ sender: Any)
    {
        if (numberOfPassengers != 4)
        {
            numberOfPassengers += 1
            numberLabel.text = String(numberOfPassengers)
            if numberOfPassengers == 4
            {
                plusButton.tintColor = .secondaryLabel
            }
            else if numberOfPassengers == 2
            {
                minusButton.tintColor = .systemTeal
            }
        }
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        
    }
    
    
    @IBAction func continueButtonAction(_ sender: Any)
    {
        print("button pressed")
        if settingForSearch == true
        {
            print("search setting")
            UserSearchTripRequest.numberOfPassengers = numberOfPassengers
            let vc = SearchMatchRequestViewController()
            vc.title = "Searching for trips".localized()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if settingForPost == true
        {
            print("post setting")
            CurrentUserTripPost.passengerNumber = numberOfPassengers
            uploadTripPostToDatabase()
    
        }
    }
    
    func uploadTripPostToDatabase()
    {
        print("CurrentUser: " + CurrentUser.UID)
        print("CurrentUserTripPostUID: " + CurrentUserTripPost.uid)
        print("CurrentUserTripPost.time: " + CurrentUserTripPost.time)
        let post = ["fullname": CurrentUserTripPost.fullname,
                    "username":
                        CurrentUserTripPost.username,
                    "uid": CurrentUserTripPost.uid,
                    "from": CurrentUserTripPost.fromLocationName,
                    "to": CurrentUserTripPost.toLocationName,
                    "time": CurrentUserTripPost.time,
                    "number of passengers": CurrentUserTripPost.passengerNumber,
                    "price": CurrentUserTripPost.price,
                    "fromCoordinateLatitude": CurrentUserTripPost.fromLocationLat, "fromCoordinateLongitude": CurrentUserTripPost.fromLocationLong,
                    "toCoordinateLatitude": CurrentUserTripPost.toLocationLat,
                    "toCoordinateLongitude": CurrentUserTripPost.toLocationLong
                    ] as [String:Any]
        storageManager.ref.child("Trips").child(CurrentUserTripPost.uid).setValue(post)
        //print("uid: " + CurrentUserTripPost.uid)
        storageManager.db.collection("users").document(CurrentUserTripPost.uid).updateData(["TripIsSet":true])
        let alert = UIAlertController(title: "Trip Posted", message: "Your trip has been posted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
