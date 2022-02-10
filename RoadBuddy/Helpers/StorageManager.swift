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
    let ref = Database.database().reference()
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()
    var profileImage = UIImage()
    
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
}
