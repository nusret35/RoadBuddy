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
    
    func currentUserProfilePictureLoad(completion: @escaping (UIImage?) -> ())
    {
        let docRef = db.collection("users").document(CurrentUser.UID)
        docRef.getDocument{ snapshot, error in
            self.storage.child(CurrentUser.profilePictureURL).downloadURL(completion: { (url, error) in
                print("profilePictureURL: " + CurrentUser.profilePictureURL)
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
    
    func retrieveAllRequestsOfUser(completion: @escaping ([[Request]]) -> ())
    {
        //First retrieve all request
        retrieveSearchRequests { searchRequests in
            print("f1 done")
            self.retrieveTaxiRequests(requests: searchRequests) { searchAndTaxiRequests in
                print("f2 done")
                self.retrievePostRequests(requests: searchAndTaxiRequests) { allRequests in
                    print("f3 done")
                    completion(self.sortRequests(requests: allRequests))
                }
            }
        }
        
    }
    
    func sortRequests(requests:[Request]) -> [[Request]]
    {
        print("sorting the requests")
        let sortedRequests = [requests]
        return sortedRequests
    }
    
    func retrieveSearchRequests(completion: @escaping ([Request]) -> ())
    {
        var requests = [Request]()
        ref.child("Search_Requests").child(CurrentUser.UID).observeSingleEvent(of: .value) { (snapshot) in
            print("function 1")
            if snapshot.exists() == true
            {
                for child in snapshot.children
                {
                    print("inside search")
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else {return}
                    let date = res["time"] as! String
                    print("search time:" + date)
                    let status = res["status"] as! String
                    let passengerNumber = res["passengerNumber"] as! Int
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to, passengerNumber: passengerNumber, date: date, status: status, type: "Trip Request")
                    requests.append(request)
                }
                completion(requests)
            }
            else
            {
                completion(requests)
            }
        }
    }
    func retrieveTaxiRequests(requests:[Request],completion: @escaping ([Request]) -> ())
    {
        var searchAndTaxiRequests = requests
        self.ref.child("Taxi_Requests").child(CurrentUser.UID).observeSingleEvent(of: .value) { (snapshot) in
            print("function 2")
            if snapshot.exists() == true
            {
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else {return}
                    let date = res["time"] as! String
                    let status = res["status"] as! String
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to, passengerNumber: 0, date: date, status: status, type: "Taxi Request")
                    searchAndTaxiRequests.append(request)
                }
                completion(searchAndTaxiRequests)
            }
            else
            {
                completion(searchAndTaxiRequests)
            }
        }
        
    }
    func retrievePostRequests(requests:[Request],completion: @escaping ([Request]) -> ())
    {
        var searchTaxiAndPostRequests = requests
        self.ref.child("Trips").child(CurrentUser.UID).observeSingleEvent(of: .value) { (snapshot) in
            print("function 3")
            if snapshot.exists() == true
            {
                print("snapshot exists")
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else { print("something is wrong")
                        return}
                    let date = res["time"] as! String
                    let status = res["status"] as! String
                    let passengerNumber = res["passengerNumber"] as! Int
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to, passengerNumber: passengerNumber, date: date, status: status, type: "Trip Post")
                    searchTaxiAndPostRequests.append(request)
                }
                completion(searchTaxiAndPostRequests)
            }
            else
            {
                print("snapshot does not exist")
                completion(searchTaxiAndPostRequests)
            }
        }
    }
    
    
}
