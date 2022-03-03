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
import CoreLocation

struct Trip
{
    var name:String
    
    var from:String
    
    var to:String
    
    var price:Int
    
    var time:String
    
    var numberOfPassenger:Int
    
    var fromLat:Double
    
    var fromLong:Double
    
    var toLat:Double
    
    var toLong:Double
    
    var uid:String
    
    var dataFromLocation:CLLocation
    
    var dataToLocation:CLLocation
    
    var status:String
}

struct TaxiTrip
{
    var username:String
    
    var from:String
    
    var to:String
    
    var time:String
    
    var fromLat:Double
    
    var fromLong:Double
    
    var toLat:Double
    
    var toLong:Double
    
    var uid:String
    
    var dataFromLocation:CLLocation
    
    var dataToLocation:CLLocation
    
    var status:String
}


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
    
    
    //******************* General functions *******************************
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
    
    //******************** Home View functions ************************
    
    func retrieveAllRequestsOfUser(completion: @escaping ([[Request]]) -> ())
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
                    let request = Request(from: from, to: to, price:0,passengerNumber: passengerNumber, date: date, status: status, type: "Trip Request")
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
                    let request = Request(from: from, to: to, price: 0,passengerNumber: 0, date: date, status: status, type: "Taxi Request")
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
                    let price = res["price"] as! Int
                    let status = res["status"] as! String
                    let passengerNumber = res["passengerNumber"] as! Int
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to,price:price, passengerNumber: passengerNumber, date: date, status: status, type: "Trip Post")
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
    
    //********************* Time View functions ***********************
    
    func checkIfThereIsAnotherRequestWithSameTime(completion: @escaping (String?) -> ())
    {
        var error:String? = nil
        ref.child("Search_Requests").child(CurrentUser.UID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let time = res["time"] as! String
                if time == UserSearchTripRequest.time
                {
                    error = "You already have a request for the same time"
                }
            }
            completion(error)
        })
    }
    
    
    func checkIfThereIsAnotherTaxiRequestWithSameTime(completion: @escaping (String?) -> ())
    {
        var error:String? = nil
        ref.child("Taxi_Requests").child(CurrentUser.UID).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let time = res["time"] as! String
                if time == UserTaxiTripRequest.time
                {
                    error = "You already have a request for the same time"
                }
            }
            completion(error)
        })
    }
    
    //***************** SearchMatchRequest functions ********************
    
    func sendingSearchRequestToFirebase(request:[String:Any])
    {
        ref.child("Search_Requests").child(CurrentUser.UID).child(UserSearchTripRequest.time).setValue(request)
        print("request sent")
    }
    
    func findTripsForTheRequest(group:DispatchGroup, completion: @escaping (Trip) -> ())
    {
        db.collection("users").document(CurrentUser.UID).updateData(["lookingForATrip":true])
        ref.child("Trips")
            .observeSingleEvent(of: .value, with: { (snapshot)  in
                if snapshot.exists() == true
                {
                    for date in snapshot.children
                    {
                        let trip = date as! DataSnapshot
                        for child in trip.children
                        {
                            print("snapshot does exist")
                            let snap = child as! DataSnapshot
                            guard let res = snap.value as? [String:Any] else {return}
                            guard let name = res["fullname"] as? String
                            else
                            {
                                print("fullname not found")
                                return
                            }
                            print(name)
                            let from = res["from"] as! String
                            let to = res["to"] as! String
                            let price = res["price"] as! Int
                            let time = res["time"] as! String
                            let numberOfPassengers = res["passengerNumber"] as! Int
                            let fromLat = res["fromCoordinateLatitude"] as! Double
                            let fromLong = res["fromCoordinateLongitude"] as! Double
                            let toLat = res["toCoordinateLatitude"] as! Double
                            let toLong = res["toCoordinateLongitude"] as! Double
                            let dUID = res["uid"] as! String
                            let status = res["status"] as! String
                            let dataFromLocation = CLLocation(latitude: fromLat, longitude:fromLong)
                            let dataToLocation = CLLocation(latitude:toLat, longitude:toLong)
                            let dataTrip = Trip(name: name, from: from, to: to, price: price, time: time, numberOfPassenger: numberOfPassengers, fromLat: fromLat, fromLong: fromLong, toLat: toLat, toLong: toLong, uid: dUID, dataFromLocation: dataFromLocation, dataToLocation: dataToLocation, status:status)
                            completion(dataTrip)
                        }
                    }
                }
                group.leave()
            })
    }
    //************* TaxiTripsMatchViewController  ******************
    func sendingTaxiRequestToFirebase(request:[String:Any])
    {
        ref.child("Taxi_Requests").child(CurrentUser.UID).child(UserTaxiTripRequest.time).setValue(request)
        print("request sent")
    }
    
    func findTripsForTaxiRequest(group:DispatchGroup, completion: @escaping (TaxiTrip) -> ())
    {
        db.collection("users").document(CurrentUser.UID).updateData(["TaxiTripIsSet":true])
        ref.child("Taxi_Requests")
            .observeSingleEvent(of: .value, with: { (snapshot)  in
                for date in snapshot.children
                {
                    let request = date as! DataSnapshot
                    for child in request.children
                    {
                        let snap = child as! DataSnapshot
                        guard let res = snap.value as? [String:Any] else {return}
                        let username = res["username"] as! String
                        print(username)
                        let from = res["from"] as! String
                        let to = res["to"] as! String
                        let time = res["time"] as! String
                        let status = res["status"] as! String
                        let fromLat = res["fromLocationLat"] as! Double
                        let fromLong = res["fromLocationLong"] as! Double
                        let toLat = res["toLocationLat"] as! Double
                        let toLong = res["toLocationLong"] as! Double
                        let uid = res["uid"] as! String
                        let dataFromLocation = CLLocation(latitude: fromLat, longitude:fromLong)
                        let dataToLocation = CLLocation(latitude:toLat, longitude:toLong)
                        let dataTrip = TaxiTrip(username: username, from: from, to: to, time: time, fromLat: fromLat, fromLong: fromLong, toLat: toLat, toLong: toLong, uid: uid, dataFromLocation: dataFromLocation, dataToLocation: dataToLocation, status: status)
                        completion(dataTrip)
                    }
                }
                group.leave()
            })
    }
                                
}
