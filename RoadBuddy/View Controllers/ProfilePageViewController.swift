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
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    var ref:DatabaseReference?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentUser.Fullname)
      //
        
        self.NameLastnameLabel.isSkeletonable = true
        self.UniversityNameLabel.isSkeletonable = true
        self.UsernameLabel.isSkeletonable = true
        self.EmailLabel.isSkeletonable = true
        self.PhoneLabel.isSkeletonable = true
        
        self.NameLastnameLabel.showAnimatedGradientSkeleton()
        self.UniversityNameLabel.showAnimatedGradientSkeleton()
        self.UsernameLabel.showAnimatedGradientSkeleton()
        self.EmailLabel.showAnimatedGradientSkeleton()
        self.PhoneLabel.showAnimatedGradientSkeleton()

            self.NameLastnameLabel.text = currentUser.Fullname
            self.UniversityNameLabel.text = currentUser.SchoolName
            self.UsernameLabel.text = currentUser.Username
            self.EmailLabel.text = currentUser.Email
            self.PhoneLabel.text = currentUser.PhoneNumber
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:{
            self.NameLastnameLabel.hideSkeleton()
            self.UniversityNameLabel.hideSkeleton()
            self.UsernameLabel.hideSkeleton()
            self.EmailLabel.hideSkeleton()
            self.PhoneLabel.hideSkeleton()
        })
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func signOutButtonAction(_ sender: Any)
    {
        createAlert(title: "Sign Out", message: "Are you sure you want to sign out?")
    }
    
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.destructive, handler: { [self] (action) in
            do
            {
            try Auth.auth().signOut()
                let registrationStoryboard = UIStoryboard(name:"Registration",bundle:nil)
                let homePageViewController = registrationStoryboard.instantiateViewController(withIdentifier: "HomePageNC") as! UINavigationController
                self.present(homePageViewController, animated: true, completion: nil)
            }
            catch
            {
                print("sign out error")
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
}
