//
//  PostViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 17.10.2021.
//

import UIKit
import QuartzCore
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage


class PostViewController: UIViewController {

    @IBOutlet weak var FromLabel: UILabel!
    
    @IBOutlet weak var ToLabel: UILabel!
    
    @IBOutlet weak var TimeLabel: UILabel!
    
    @IBOutlet weak var PassengerLabel: UILabel!
    
    @IBOutlet weak var PriceLabel: UILabel!
    
    @IBOutlet weak var DeleteTripButton: UIButton!
    
    @IBOutlet weak var AddTripButton: UIButton!
    
    @IBOutlet weak var setView: UIView!
    
    
    @IBOutlet weak var TabBar: UITabBarItem!
    
    let db = Firestore.firestore()
   
    var userName = ""
    
    var uid = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView.alpha = 0
        self.FromLabel.alpha = 0
        self.ToLabel.alpha = 0
        self.TimeLabel.alpha = 0
        self.PassengerLabel.alpha = 0
        self.PriceLabel.alpha = 0
        self.DeleteTripButton.alpha = 0
        SetUpElements()
    }
    
    
    //dataları aldığın kısmı SetUpElements'ten çıkar ve ortak bir yere koy. Böyle efficient değil
    func SetUpElements()
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
            guard let TripIsSet = data["TripIsSet"] as? Bool else{
                return
            }
            if TripIsSet == true
            {
                guard let username = data["username"] as? String else{
                    return
                }
                self.userName = username
                Database.database().reference().child("Trips").child(self.uid).observeSingleEvent(of: .value)
                { (snapshot) in
                    guard let res = snapshot.value as? [String:Any] else {return}
                    self.FromLabel.text = res["from"] as! String
                    self.ToLabel.text = res["to"] as! String
                    self.TimeLabel.text = res["time"] as! String
                    self.PassengerLabel.text = "\(res["number of passengers"]!)"
                    self.PriceLabel.text = res["price"] as! String
            
                }
                self.setView.alpha = 1
                self.FromLabel.alpha = 1
                self.ToLabel.alpha = 1
                self.TimeLabel.alpha = 1
                self.PassengerLabel.alpha = 1
                self.PriceLabel.alpha = 1
                self.DeleteTripButton.alpha = 1
                self.AddTripButton.alpha = 0
            }
            else
            {
                self.setView.alpha = 0
                self.FromLabel.alpha = 0
                self.ToLabel.alpha = 0
                self.TimeLabel.alpha = 0
                self.PassengerLabel.alpha = 0
                self.PriceLabel.alpha = 0
                self.DeleteTripButton.alpha = 0
                self.AddTripButton.alpha = 1
            }
        }
        }
    
    @IBAction func AddTripButtonAction(_ sender: Any) {
        
            let PostTripViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripVC") as! PostTripViewController
            
            present(PostTripViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func DeleteTripButtonAction(_ sender: Any)
    {
        createAlert(title: "Deleting Trip", message: "Are you sure you want to delete your posted trip?")
    }
    
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { [self] (action) in
            Database.database().reference().child("Trips").child(self.uid).removeValue()
            self.db.collection("users").document(self.uid).updateData(["TripIsSet":false])

            FromLoc = "Choose a location..."
            ToLoc = "Choose a location..."
            TimeString = "Choose date and time..."

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
    
}



