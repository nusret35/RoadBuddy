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

class ProfilePageViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var NameLastnameLabel: UILabel!
    @IBOutlet weak var UniversityNameLabel: UILabel!
    @IBOutlet weak var UsernameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var PhoneLabel: UILabel!
    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var signOutButton: UIButton!
    
    var ref:DatabaseReference?
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(CurrentUser.Fullname)
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

            self.NameLastnameLabel.text = CurrentUser.Fullname
            self.UniversityNameLabel.text = CurrentUser.SchoolName
            self.UsernameLabel.text = CurrentUser.Username
            self.EmailLabel.text = CurrentUser.Email
            self.PhoneLabel.text = CurrentUser.PhoneNumber
        if CurrentUser.profilePictureIsSet
        {
            print("there exist a pp")
            profilePictureLoad()
        }
        else
        {
            self.ProfilePicture.image = UIImage(named: "emptyProfilePicture")
        }
        
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
    
    
    @IBAction func changeProfilePictureButtonAction(_ sender: Any)
    {
        presentPhotoActionSheet()
    }

    func profilePictureLoad()
    {
        let docRef = db.collection("users").document(CurrentUser.UID)
        docRef.getDocument{ snapshot, error in
            self.storage.child("/images/\(CurrentUser.profilePictureURL)").downloadURL(completion: { (url, error) in
                guard let url = url else
                {
                    print("profile photo url not found")
                    return
                }
                
                do
                {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    self.ProfilePicture.image = image
                    self.ProfilePicture.layer.cornerRadius = self.ProfilePicture.frame.size.width/2
                    self.ProfilePicture.clipsToBounds = true
                }
                catch
                {
                    print("profile photo error")
                }
            })
            }
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

extension ProfilePageViewController:UIImagePickerControllerDelegate
{
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "You can choose your profile picture from your library or take a photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {[weak self]_ in
            self?.presentPhotoPicker()
            
        }))
    present(actionSheet, animated: true)
    }
    
    func presentPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.ProfilePicture.image = selectedImage
        guard let imageData = selectedImage.pngData() else {
            return
        }
        
        let docRef = db.collection("users").document(CurrentUser.UID)
        docRef.updateData(["profilePictureIsSet":true])
        
        docRef.getDocument{ snapshot, error in
                
            self.storage.child("/images/\(CurrentUser.UID)").putData(imageData, metadata: nil, completion: nil)
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

}
