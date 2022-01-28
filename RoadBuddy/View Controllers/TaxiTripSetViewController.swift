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

var fromLocTaxi = ""

var toLocTaxi = ""

var timeStringTaxi = ""

protocol TaxiTripSetViewControllerDelegate: AnyObject
{
    func taxiTripSetViewController(_ vc: TaxiTripSetViewController, fromLoc: String, toLoc: String, time: String)
}

class TaxiTripSetViewController: UIViewController {

    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var backButton: UIButton!

    var ref:DatabaseReference?
    
    let db = Firestore.firestore()
    
    var buttonTitle:String! = "Choose a location..."

    var timeButtonTitle:String! = "Choose date and time..."
    
    var uid = ""
    
    var username = ""
    
    var fullname = ""
    
    weak var delegate:TaxiTripSetViewControllerDelegate?

    override func viewDidLoad(){
        super.viewDidLoad()
        
        ref = Database.database().reference()
        FromButton.setTitle(buttonTitle, for: .normal)
        ToButton.setTitle(buttonTitle, for: .normal)
        timeButton.setTitle(timeButtonTitle, for: .normal)
        Utilities.styleFilledButton(continueButton)
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
        let STFromViewController = storyboard?.instantiateViewController(withIdentifier:  "STFromVC") as! STFromViewController
        STFromViewController.delegate = self
        present(STFromViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func toButtonAction(_ sender: Any)
    {
        let STToViewController = storyboard?.instantiateViewController(withIdentifier: "STToVC") as! STToViewController
        STToViewController.delegate = self
        present(STToViewController, animated: true, completion: nil)
    }
    
    @IBAction func timeButtonAction(_ sender: Any)
    {
        let STTimeViewController = storyboard?.instantiateViewController(withIdentifier: "STTimeVC") as! STTimeViewController
        STTimeViewController.delegate = self
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
                delegate?.taxiTripSetViewController(self, fromLoc: fromLoc, toLoc: toLoc, time: timeString)
                db.collection("users").document(uid).updateData(["TaxiTripIsSet":true])
                let post = ["fullname":fullname,
                            "uid":self.uid,
                            "from": fromLocTaxi,
                             "to":   toLocTaxi,
                            "time": timeStringTaxi,
                            "fromCoordinateLatitude": stFromLatitude,
                            "fromCoordinateLongitude": stFromLongitude,
                            "toCoordinateLatitude": stToLatitude,
                            "toCoordinateLongitude": stToLongitude
                ] as [String : Any]
    
                    ref?.child("Taxi_Trips").child(uid).setValue(post)
                let mainTabController = storyboard?.instantiateViewController(withIdentifier: "MainTabController") as! MainTabController
                mainTabController.selectedViewController = mainTabController.viewControllers?[3]
                present(mainTabController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension TaxiTripSetViewController: STFromViewControllerDelegate
{
    func stFromViewController(_ vc: STFromViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String)
    {
        fromLocTaxi = btitle
        FromButton.setTitle(btitle, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

extension TaxiTripSetViewController: STToViewControllerDelegate
{
    func stToViewController(_ vc: STToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String) {
        toLocTaxi = btitle
        ToButton.setTitle(btitle, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

extension TaxiTripSetViewController: STTimeViewControllerDelegate
{
    func stTimeViewController(_ vc: STTimeViewController, time: String) {
        timeStringTaxi = time
        timeButton.setTitle(time, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
