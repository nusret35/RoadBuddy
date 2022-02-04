//
//  TaxiTripSetViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 21.11.2021.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage

var fromLocTaxi = "Choose a location..."

var toLocTaxi = "Choose a location..."

var timeStringTaxi = "Choose date and time..."

class TaxiTripSetViewController: UIViewController {

    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!

    var ref:DatabaseReference?
    
    let db = Firestore.firestore()
    
    let mapsStoryboard = UIStoryboard(name:"Maps",bundle:nil)
    
    var uid = ""
    
    var username = ""
    
    var fullname = ""
    

    override func viewDidLoad(){
        super.viewDidLoad()
        
        ref = Database.database().reference()
        errorLabel.alpha = 0
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        let docRef = db.collection("users").document(userID)
        docRef.getDocument{ snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            guard let UID = data["uid"] as? String else{
                return
            }
            guard let userName = data["username"] as? String else{
                return
            }
            guard let firstname = data["firstname"] as? String else{
                return
            }
            guard let lastname = data["lastname"] as? String else{
                return
            }
            self.uid = UID
            self.username = userName
            self.fullname = firstname + " " + lastname
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FromButton.setTitle(fromLocTaxi, for: .normal)
        ToButton.setTitle(toLocTaxi, for: .normal)
        timeButton.setTitle(timeStringTaxi, for: .normal)
    }
    
    //FUNCTIONS
    
    func validateFields() ->String? {
        if FromButton.titleLabel!.text! == "Choose a location..." || ToButton.titleLabel!.text! == "Choose a location..."
        {
            return "Please choose a location"
        }
        else if timeButton.titleLabel!.text! == "Choose date and time..."
        {
            return "Please choose a time frame"
        }
        return nil
    }
    
    func showError (message:String)
    
        {
            errorLabel.text = message
            errorLabel.alpha = 1
        }
    
    //BUTTON ACTIONS
    
    @IBAction func fromButtonAction(_ sender: Any)
    {
        let STFromNavigationController = mapsStoryboard.instantiateViewController(withIdentifier:  "STFromNC") as!
        UINavigationController
        present(STFromNavigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func toButtonAction(_ sender: Any)
    {
        let STToNavigationController = mapsStoryboard.instantiateViewController(withIdentifier: "STToNC") as! UINavigationController
        present(STToNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func timeButtonAction(_ sender: Any)
    {
        let STTimeViewController = storyboard?.instantiateViewController(withIdentifier: "STTimeVC") as! STTimeViewController
        present(STTimeViewController, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonAction(_ sender: Any)
    {
        let error = validateFields()
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
                db.collection("users").document(uid).updateData(["TaxiTripIsSet":true])
                let post = ["fullname":fullname,
                            "uid":self.uid,
                            "from": fromLocTaxi,
                             "to":   toLocTaxi,
                            "time": timeStringTaxi,
                            "fromCoordinateLatitude": stFromLocation.coordinate.latitude,
                            "fromCoordinateLongitude": stFromLocation.coordinate.longitude,
                            "toCoordinateLatitude": stToLocation.coordinate.latitude,
                            "toCoordinateLongitude": stToLocation.coordinate.longitude
                ] as [String : Any]
    
                    ref?.child("Taxi_Trips").child(uid).setValue(post)
                let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                mainTabController.selectedViewController = mainTabController.viewControllers?[3]
                present(mainTabController, animated: true, completion: nil)
        }
    }
    
    
}

