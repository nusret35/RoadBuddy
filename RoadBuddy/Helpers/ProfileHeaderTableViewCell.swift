//
//  HeaderTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 9.02.2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

protocol ProfileHeaderTableViewCellDelegate:AnyObject{
    func didTapButton()
}


class ProfileHeaderTableViewCell: UITableViewCell, UINavigationControllerDelegate {
    
    weak var delegate: ProfileHeaderTableViewCellDelegate?
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    
    static let identifier = "ProfileHeaderTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if currentUser.profilePictureIsSet
        {
            profilePictureLoad()
        }
        else
        {
            profilePicture.image = UIImage(named:"emptyProfilePicture")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func changeProfilePicture(_ sender: Any)
    {
        delegate?.didTapButton()
    }
    
    func profilePictureLoad()
    {
        let docRef = db.collection("users").document(currentUser.UID)
        docRef.getDocument{ snapshot, error in
            self.storage
                .child("/images/\(currentUser.profilePictureURL)").downloadURL(completion: { (url, error) in
                guard let url = url else
                {
                    print("profile photo url not found")
                    return
                }
                
                do
                {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    self.profilePicture.image = image
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2
                    self.profilePicture.clipsToBounds = true
                }
                catch
                {
                    print("profile photo error")
                }
            })
            }
    }
    
    
}

extension ProfileHeaderTableViewCell:UIImagePickerControllerDelegate
{
    /*
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
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.profilePicture.image = selectedImage
        guard let imageData = selectedImage.pngData() else {
            return
        }
        
        let docRef = db.collection("users").document(currentUser.UID)
        docRef.updateData(["profilePictureIsSet":true])
        
        docRef.getDocument{ snapshot, error in
                
            self.storage.child("/images/\(currentUser.UID)").putData(imageData, metadata: nil, completion: nil)
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    

}
