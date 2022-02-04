//
//  ShareTaxiViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 17.11.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage


class ShareTaxiViewController: UIViewController
{

    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var backgroundView: UIView!
    
    let db = Firestore.firestore()
    
    var uid = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetUpElement()
    }
    func SetUpElement()
    {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        uid = userID
        let docRef = db.collection("users").document(userID)
        docRef.getDocument{ snapshot, error in
            guard let data = snapshot?.data(), error == nil else{
                return
            }
            guard let TaxiTripIsSet = data["TaxiTripIsSet"] as? Bool else{
                return
            }
        if (TaxiTripIsSet)
        {
            guard let username = data["username"] as? String else{
                return
            }
            Database.database().reference().child("Taxi_Trips").child(self.uid).observeSingleEvent(of: .value)
            {
                (snapshot) in
                guard let res = snapshot.value as? [String:Any] else
                {return}
                self.fromLabel.text = res["from"] as! String
                self.toLabel.text = res["to"] as! String
                self.timeLabel.text = res["time"] as! String
            }
            self.addButton.alpha = 0
            self.fromLabel.alpha = 1
            self.toLabel.alpha = 1
            self.timeLabel.alpha = 1
            self.backgroundView.alpha = 1
            
        }
        else
        {
            self.addButton.alpha = 1
            self.fromLabel.alpha = 0
            self.toLabel.alpha = 0
            self.timeLabel.alpha = 0
            self.backgroundView.alpha = 0
            }
        }
    }
    
    
    @IBAction func AddButtonTapped(_ sender: Any)
    {
        let TaxiTripSetViewController = storyboard?.instantiateViewController(withIdentifier: "TaxiTripSetVC") as! TaxiTripSetViewController
        present(TaxiTripSetViewController, animated: true, completion: nil)
    }
}
