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


struct TemporaryStruct
{
    var username:String
 
    var uid:String
    
    var tripID:String
    
    var status:String
    
}

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
    
    var tripID:String
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
    
    func otherUserProfilePictureLoad(_ uid:String,completion: @escaping FinishedDownload)
    {
        var data = Data()
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { [self] snapshot, error in
            storage.child(userProfilePictureString(uid)).downloadURL {
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
                    let image = UIImage(named: "emptyProfilePicture")
                    completion(image)
                }
            }
        }
    }
    
    func userProfilePictureString(_ uid:String) -> String
    {
        return "/images/\(uid)"
    }
    
    
    func getUsernameByUID(_ uid:String,completion: @escaping (String) -> ())
    {
        ref.child("Users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() == true
            {
                guard let res = snapshot.value as? [String:Any]
                else
                {
                    print("user not found")
                    return
                }
                let username = res["username"] as! String
                completion(username)
            }
            else
            {
                print("user not found")
            }
        }
    }
    
    func getUidByTripID(_ tripID:String) -> String
    {
        let index = tripID.firstIndex(of: "_")!
        let uid = tripID[..<index]
        return String(uid)
    }
    
    func getUidByTaxiTripID(_ tripID:String) -> String
    {
        let start_index = tripID.index(tripID.startIndex,offsetBy: 5)
        let sub_str = String(tripID[start_index...])
        let end_index = sub_str.firstIndex(of: "_")!
        guard let final_str = sub_str[..<end_index] as? String.SubSequence else
        {
            print("final_str was not created")
        }
        return String(final_str)
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
                    let uid = res["uid"] as! String
                    let date = res["time"] as! String
                    let status = res["status"] as! String
                    let passengerNumber = res["passengerNumber"] as! Int
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let price = res["price"] as! Int
                    let request = Request(from: from, to: to, price:price,passengerNumber: passengerNumber, date: date, status: status, type: "Trip Request", tripID: self.createTripID(uid: uid, date: date))
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
                    let uid = res["uid"] as! String
                    let date = res["time"] as! String
                    let status = res["status"] as! String
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to, price: 0,passengerNumber: 0, date: date, status: status, type: "Taxi Request", tripID:self.createTripID(uid: uid, date: date))
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
                    let uid = res["uid"] as! String
                    let date = res["time"] as! String
                    let price = res["price"] as! Int
                    let status = res["status"] as! String
                    let passengerNumber = res["passengerNumber"] as! Int
                    let from = res["from"] as! String
                    let to = res["to"] as! String
                    let request = Request(from: from, to: to,price:price, passengerNumber: passengerNumber, date: date, status: status, type: "Trip Post", tripID: self.createTripID(uid: uid, date: date))
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
    
    func getPendingSearchRequestsArray(date:String, completion: @escaping ([TemporaryStruct]) -> () )
    {
        var array = [TemporaryStruct]()
        let group = DispatchGroup()
        ref.child("Search_Requests").child(CurrentUser.UID).child(date).child("Pending_Requests").observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children
            {
                let trip = child as! DataSnapshot
                guard let res = trip.value as? [String:Any] else {return}
                let uid = String(self.getUidByTripID(trip.key))
                let status = res["status"] as! String
                group.enter()
                self.getUsernameByUID(uid) { username in
                    let element = TemporaryStruct(username:username, uid: uid ,tripID: trip.key, status: status)
                    array.append(element)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                completion(array)
            }
        }
    }
    
    func getPendingTaxiRequestsArray(tripID:String, completion: @escaping ([TemporaryStruct]) -> ())
    {
        let group = DispatchGroup()
        var array = [TemporaryStruct]()
        let uid = getUidByTripID(tripID)
        print(uid)
        let tid = "taxi_" + tripID
        ref.child("Taxi_Requests").child(CurrentUser.UID).child(tid).child("Pending_Requests").observeSingleEvent(of: .value) { [self] snapshot in
            if snapshot.exists() == true
            {
                for child in snapshot.children
                {
                    let trip = child as! DataSnapshot
                    guard let res = trip.value as? [String:Any] else {
                        print("no value")
                        return
                    }
                    print(trip.key)
                    let tripOwnerUID = String(getUidByTaxiTripID(trip.key))
                    let status = res["status"] as! String
                    group.enter()
                    getUsernameByUID(tripOwnerUID) { username in
                        
                        let element = TemporaryStruct(username:username, uid: tripOwnerUID, tripID: trip.key, status: status)
                        array.append(element)
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    completion(array)
                }
            }
            else
            {
                print("snapshot does not exist")
            }
        }
    }
    
    //***************************************************** Time View functions *********************************************************
    
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
    
    func checkIfUserLoggedIn() -> Bool
    {
        if Auth.auth().currentUser?.uid == nil
        {
            return false
        }
        return true
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
    //Add this function later
    func updateSearchRequestsDatabase()
    {
        
    }
    //************* TaxiTripsMatchViewController  ******************
    func sendingTaxiRequestToFirebase(request:[String:Any],completion: @escaping (String)->())
    {
        let tripID = "taxi_" + createTripID(uid: UserTaxiTripRequest.uid, date: UserTaxiTripRequest.time)
        print("tripID: " + tripID)
        ref.child("Taxi_Requests").child(CurrentUser.UID).child(tripID).setValue(request)
        print("taxi request sent")
        completion(tripID)
    }
    
    func findTripsForTaxiRequest(group:DispatchGroup, completion: @escaping (TaxiTrip) -> ())
    {
        db.collection("users").document(CurrentUser.UID).updateData(["TaxiTripIsSet":true])
        ref.child("Taxi_Requests")
            .observeSingleEvent(of: .value, with: { (snapshot)  in
                if snapshot.exists() == true
                {
                    for date in snapshot.children
                    {
                        let request = date as! DataSnapshot
                        let parentUID = request.key
                        if parentUID != CurrentUser.UID
                        {
                            for child in request.children
                            {
                                print("inside second snapshot")
                                let snap = child as! DataSnapshot
                                guard let tripID = snap.key as String? else {
                                    print("tripID not found")
                                    return
                                }
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
                                let dataTrip = TaxiTrip(username: username, from: from, to: to, time: time, fromLat: fromLat, fromLong: fromLong, toLat: toLat, toLong: toLong, uid: uid, dataFromLocation: dataFromLocation, dataToLocation: dataToLocation, status: status, tripID: tripID)
                                if status == "Pending"
                                {
                                    completion(dataTrip)
                                }
                            }
                        }
                    }
                }
                group.leave()
            })
    }
    
    //************* InboxViewController ******************************************
    
    func tripRequestAccepted(by:String, sender:InboxObject, chatID:String,taxiTripID:String)
    {
        let index = sender.tripID.firstIndex(of:"_")!
        updateChat(chatID: chatID)
        if sender.tripID[...index] != "taxi_"
        {
            updateCurrentUserInbox(by: by, sender: sender, chatID: chatID)
            updateSenderInbox(sender: sender, chatID: chatID)
            updateSearchRequestStatus(sender: sender, by: by)
        }
        else
        {
            print("updating taxi request")
            updateTaxiRequestStatus(sender: sender, by: by, tripID: taxiTripID,chatID:chatID)
        }
    }
    
    func updateCurrentUserInbox(by:String, sender:InboxObject, chatID:String)
    {
        let currentUserInboxInfo = ["chatId":chatID,"last_message":"", "status":sender.status,"uid":sender.uid,"username":sender.username,"tripID":sender.tripID] as [String:Any]
        ref.child("User_Inbox").child(by).child("Inbox").child(sender.tripID).child(sender.uid).setValue(currentUserInboxInfo)
    }
    
    func updateSenderInbox(sender:InboxObject,chatID:String)
    {
        let senderInboxInfo = ["chatId":chatID,"last_message":"","status":"Accepted","uid":CurrentUser.UID,"username":CurrentUser.Username,"tripID":sender.tripID] as [String:Any]
        ref.child("User_Inbox").child(sender.uid).child("Inbox").child(sender.tripID).child(CurrentUser.UID).setValue(senderInboxInfo)
    }
    
    func updateChat(chatID:String)
    {
        let lastMessageValueForFirebase = ["last_message":""] as [String:Any]
        ref.child("Chats").child(chatID).setValue(lastMessageValueForFirebase)
    }
    
    func updateTaxiRequestStatus(sender:InboxObject,by:String, tripID:String,chatID:String)
    {
        let senderInboxInfo = ["chatId":chatID,"last_message":"","status":"Accepted","uid":CurrentUser.UID,"username":CurrentUser.Username,"tripID":tripID] as [String:Any]
        print("tripID: " + tripID + " sender.tripID: " + sender.tripID)
        ref.child("Taxi_Requests").child(CurrentUser.UID).child(tripID).updateChildValues(["status":"Accepted"])
        ref.child("User_Inbox").child(CurrentUser.UID).child("Inbox").child(tripID).child(sender.uid).updateChildValues(["status":"Accepted","chatId":chatID])
        ref.child("User_Inbox").child(sender.uid).child("Inbox").child(tripID).child(CurrentUser.UID).setValue(senderInboxInfo)
        ref.child("Taxi_Requests").child(sender.uid).child(sender.tripID).updateChildValues(["status":"Accepted"])
        ref.child("Taxi_Requests").child(sender.uid).child(sender.tripID).child("Pending_Requests").child(tripID).updateChildValues(["status":"Accepted"])
    }
    
    
    func updateSearchRequestStatus(sender:InboxObject,by:String)
    {
        ref.child("Search_Requests").child(sender.uid).observeSingleEvent(of: .value) { snapshot in
            for child in snapshot.children
            {
                let date = child as! DataSnapshot
                guard let dateForPath = date.key as String?
                else
                {
                    print("date for path string not found")
                    return
                }
                self.ref.child("Search_Requests").child(sender.uid).child(dateForPath).child("Pending_Requests").observeSingleEvent(of: .value) { [self] tripIDs in
                    for trip in tripIDs.children
                    {
                        let id = trip as! DataSnapshot
                        guard let idString = id.key as String?
                        else
                        {
                            print("id key not found ")
                            return
                        }
                        if idString == sender.tripID
                        {
                            returnPriceOfTrip(by: by, tripID: sender.tripID) { price in
                                ref.child("Search_Requests").child(sender.uid).child(dateForPath).updateChildValues(["status":"Accepted","price":price])
                                ref.child("Search_Requests").child(sender.uid).child(dateForPath).child("Pending_Requests").child(idString).updateChildValues(["status":"Accepted"])
                            }
                        }
                    }
                }
            }
        }
    }
    
    func returnPriceOfTrip(by:String, tripID:String,completion: @escaping (Int) -> ())
    {
        ref.child("Trips").child(by).child(tripID).observeSingleEvent(of: .value) { snapshot in
            guard let res = snapshot.value as? [String:Any] else {return}
            let price = res["price"] as! Int
            completion(price)
        }
    }
    //**************** PostTripPriceViewController ****************
    
    func createTripID(uid:String,date:String) -> String
    {
        let tripID = uid + "_" + date
        return tripID
    }
    
    //**************** SelectedRequestViewController *****************
    
    func deleteTripRequest()
    {
        
    }
    
    func deleteTaxiRequest()
    {
        
    }
    
    func deleteTripPost()
    {
        
    }
    
    //********** EditProfileViewController **********
    func changeProfilePicture(imageData:Data)
    {
        let docRef = storageManager.db.collection("users").document(CurrentUser.UID)
        docRef.updateData(["profilePictureIsSet":true])
        
        docRef.getDocument{ snapshot, error in
            self.storage.child("/images/\(CurrentUser.UID)").putData(imageData, metadata: nil, completion: nil)
            }
    }
}
