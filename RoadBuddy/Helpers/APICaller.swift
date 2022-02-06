//
//  APICaller.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 16.12.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import CoreLocation

struct Data
{
    var driverName:String
    
    var fromLocation:String
    
    var toLocation:String
    
    var price:String
    
    var time:String
    
    var numberOfPassengers:Int
    
    var uid:String
    
}

struct TaxiTripData
{
    var passengerName:String
    
    var uid:String
    
    var fromLocation:String
    
    var toLocation:String
    
    var time:String
    
}

class CurrentUserData
{
    let db = Firestore.firestore()
    
    var Fullname = ""
    
    var Username = ""
    
    var Email = ""
    
    var PhoneNumber = ""
    
    var SchoolName = ""
    
    var UID = ""
    
    func fetchData()
    {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not found")
            return
        }
        let docRef = self.db.collection("users").document(userID)
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
        
        guard let uid =  data["uid"] as? String else{
            return
        }
        
        guard let username = data["username"] as? String else{
            return
        }
        guard let email = data["email"] as? String else{
            return
        }
        guard let phoneNumber = data["phoneNumber"] as? String else{
            return
        }
        guard let schoolName = data["schoolName"] as? String else{
            return
        }
        
        self.Fullname = firstname + " " + lastname
        self.Username = "@" + username
        self.UID = uid
        self.Email = email
        self.PhoneNumber = phoneNumber
        self.SchoolName = schoolName
        print("Fullname: " + self.Fullname)
        print("Schoolname: " + self.SchoolName)
        }
    }
    
}
