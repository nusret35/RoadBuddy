//
//  PostTripPriceViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 16.02.2022.
//

import UIKit

class PostTripPriceViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    private var price = 1
    
    private var minimumPrice = 1
    
    private var maximumPrice = 10
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        continueButton.setTitle("Continue".localized(), for: .normal)
        numberLabel.text = String(minimumPrice)
        minusButton.tintColor = .secondaryLabel
        minusButton.setTitle("", for: .normal)
    }

    @IBAction func continueButtonAction(_ sender: Any)
    {
        CurrentUserTripPost.price = price
        uploadTripPostToDatabase()

    }
    
    @IBAction func minusButtonAction(_ sender: Any)
    {
        if (price != 1)
        {
            price -= 1
            numberLabel.text = String(price) + " ₺"
            if price == minimumPrice
            {
                minusButton.tintColor = .secondaryLabel
            }
            else if price == (maximumPrice-1)
            {
                
                plusButton.tintColor = .systemTeal
            }
        }

        
    }
    
    @IBAction func plusButtonAction(_ sender: Any)
    {
        if (price != maximumPrice)
        {
            price += 1
            numberLabel.text = String(price) + " ₺"
            if price == maximumPrice
            {
                plusButton.tintColor = .secondaryLabel
            }
            else if price == (minimumPrice + 1)
            {
                minusButton.tintColor = .systemTeal
            }
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
                    "status": "Pending",
                    "passengerNumber": CurrentUserTripPost.passengerNumber,
                    "price": CurrentUserTripPost.price,
                    "fromCoordinateLatitude": CurrentUserTripPost.fromLocationLat, "fromCoordinateLongitude": CurrentUserTripPost.fromLocationLong,
                    "toCoordinateLatitude": CurrentUserTripPost.toLocationLat,
                    "toCoordinateLongitude": CurrentUserTripPost.toLocationLong,
                    ] as [String:Any]
        storageManager.ref.child("Trips").child(CurrentUserTripPost.uid).child(storageManager.createTripID(uid: CurrentUserTripPost.uid, date: CurrentUserTripPost.time)).setValue(post)
        storageManager.db.collection("users").document(CurrentUserTripPost.uid).updateData(["TripIsSet":true])
        let alert = UIAlertController(title: "Trip Posted", message: "Your trip has been posted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
