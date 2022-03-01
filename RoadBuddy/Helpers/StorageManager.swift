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
    
    func retrieveAllRequestsOfUser(group:DispatchGroup,completion: @escaping ([[Request]]) -> ())
    {
        //First retrieve all request
            self.retrieveSearchRequests { searchRequests in
                self.retrieveTaxiRequests(requests: searchRequests) { searchAndTaxiRequests in
                    self.retrievePostRequests(requests: searchAndTaxiRequests) { allRequests in
                        completion(self.sortAndDivideRequests(allRequests: allRequests))
                            
                        }
                    }
                }
    }
    
    func sortAndDivideRequests(allRequests:[Request]) -> [[Request]]
    {
        var requests = allRequests
        var sortedAndDividedRequests = [[Request]]()
        print("sorting the requests")
        print(String(requests.count))
        if requests.isEmpty == false
        {
            var sortedRequests:[Request] = []
            while requests.isEmpty == false
            {
                var date1 = myDateFormat.stringToDate(requests[0].date)
                var date1_index = 0
                if (requests.count != 1)
                {
                    for temp in 0...requests.count-1
                    {
                        let date2 = myDateFormat.stringToDate(requests[temp].date)
                        if date2 < date1
                        {
                           // print("date2 < date1 (date2: " +  requests[temp].date+" date1: "+requests[date1_index].date)
                            date1_index = temp
                            date1 = date2
                        }
                    }
                }
                sortedRequests.append(requests[date1_index])
                while date1_index != requests.count-1
                {
                    requests[date1_index] = requests[date1_index+1]
                    date1_index+=1
                }
                let dummy = requests.popLast()
                
            }
            sortedAndDividedRequests = divideSortedRequestsIntoSections(sortedRequests: sortedRequests)
        }
        //print(String(sortedAndDividedRequests[0].count))
        return sortedAndDividedRequests
    }
    
    func divideSortedRequestsIntoSections(sortedRequests: [Request]) -> [[Request]]
    {
        var completeRequests = [[Request]]()
        var currentDay = ""
        var section = [Request]()
        for i in sortedRequests
        {
            if currentDay != myDateFormat.takeDayFromStringDate(i.date)
            {
                currentDay = myDateFormat.takeDayFromStringDate(i.date)
                if section.isEmpty == false
                {
                    print(currentDay)
                    completeRequests.append(section)
                    section = [Request]()
                    section.append(i)
                }
                else
                {
                    section.append(i)
                }
            }
            else
            {
                section.append(i)
            }
        }
        completeRequests.append(section)
        //print("divided r count: " + String(completeRequests.count))
        return completeRequests
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
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else {return}
                    let date = res["time"] as! String
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
