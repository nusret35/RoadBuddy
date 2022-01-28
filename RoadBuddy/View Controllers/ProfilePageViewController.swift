//
//  ProfilePageViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 3.10.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import SkeletonView

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var NameLastnameLabel: UILabel!
    @IBOutlet weak var UniversityNameLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var AboutYouLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!
    
    var ref:DatabaseReference?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute:{
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
            self.NameLastnameLabel.text = firstname + " " + lastname
            self.UsernameLabel.text = "@" + username
            self.EmailLabel.text = email
            self.PhoneLabel.text = phoneNumber
            self.UniversityNameLabel.text = schoolName
            
            if (profileDataLoad == false)
            {
                self.NameLastnameLabel.stopSkeletonAnimation()
                self.UniversityNameLabel.stopSkeletonAnimation()
                self.UsernameLabel.stopSkeletonAnimation()
                self.EmailLabel.stopSkeletonAnimation()
                self.PhoneLabel.stopSkeletonAnimation()
                self.view.hideSkeleton()
                profileDataLoad = true
            }
            
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if (profileDataLoad == false)
        {
            NameLastnameLabel.isSkeletonable = true
            UniversityNameLabel.isSkeletonable = true
            UsernameLabel.isSkeletonable = true
            EmailLabel.isSkeletonable = true
            PhoneLabel.isSkeletonable = true
            NameLastnameLabel.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
            UniversityNameLabel.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
            UsernameLabel.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
            EmailLabel.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
            PhoneLabel.showSkeleton(usingColor: .gray, transition: .crossDissolve(0.25))
        }
    }
    

}
