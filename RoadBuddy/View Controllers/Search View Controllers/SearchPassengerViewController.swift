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
        
    @IBOutlet weak var continueButton: UIButton!
    private var numberOfPassengers = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.setTitle("Continue".localized(), for: .normal)
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
            let vc = storyboard?.instantiateViewController(withIdentifier: "PostTripPriceVC") as! PostTripPriceViewController
            vc.title = "Set price"
            navigationController?.pushViewController(vc, animated: true)
    
        }
    }
    
    
    
    
    
}
