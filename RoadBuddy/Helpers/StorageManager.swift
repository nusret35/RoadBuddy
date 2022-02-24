//
//  StorageManager.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 9.02.2022.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class StorageManager
{
    var ref:DatabaseReference! =
    {
        return Database.database().reference()
    }()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var profileImage = UIImage()
    
    typealias FinishedDownload = (UIImage?) -> ()
    
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
                    self.profileImage = image!
                }
                catch
                {
                    print("profile photo error")
                }
            })
            }
    }
    
    func otherUserProfilePictureLoad(_ otherUser:InboxObject,completion: @escaping FinishedDownload)
    {
        var data = Data()
        let docRef = db.collection("users").document(otherUser.uid)
        docRef.getDocument { snapshot, error in
            self.storage.child(otherUser.profilePictureURL).downloadURL {
                (url, error) in
                guard let url = url else
                {
                    print("profile photo url not found")
                    return
                }
                do
                {
                    let data = try Data(contentsOf: url)
                    let image = UIImage(data: data)
                    completion(image)
                }
                catch
                {
                    print("profile photo error")
                }
            }
        }
    }
    
    func userProfilePictureString(_ uid:String) -> String
    {
        return "/images/\(uid)"
    }
    
}
