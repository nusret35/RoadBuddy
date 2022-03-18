//
//  TaxiTripsMatchViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 20.02.2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import CoreLocation

class TaxiTripsMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var request = [String:Any]()
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    
    private var taxiTrips:[TaxiTripData] = []
    
    private var models = [TripPost]()
    
    private var matchFound = false
    
    private var userTripID = String()
    
    private let taxiTripRequestFromLocation = CLLocation(latitude: UserTaxiTripRequest.fromCoordinateLat, longitude: UserTaxiTripRequest.fromCoordinateLong)
    
    private let taxiTripRequestToLocation = CLLocation(latitude: UserTaxiTripRequest.toCoordinateLat, longitude: UserTaxiTripRequest.toCoordinateLong)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.addSubview(tableView)
        setUpElements()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpElements()
    {
        setUpTableView()
        sendTaxiRequest
        {   userTripID in
            self.userTripID = userTripID
            self.matchRequest()
        }
    }

    private func setUpTableView()
    {
        tableView.isHidden = false
        tableView.backgroundColor = .systemBackground
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.taxiPost = true
        cell.configure(with: self.models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.models.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 270
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return myDateFormat.takeDayFromStringDate(UserTaxiTripRequest.time)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var boolReturn = false
        let tripID = "taxi_" + models[indexPath.row].uid + "_" + models[indexPath.row].time
        storageManager.ref.child("User_Inbox").child(models[indexPath.row].uid).child("Inbox").observeSingleEvent(of: .value) { [self] snapshot in
            if snapshot.exists() == true
            {
                for trip in snapshot.children
                {
                    let trips = trip as! DataSnapshot
                    for child in trips.children
                    {
                        let snap = child as! DataSnapshot
                        guard let res = snap.value as? [String:Any] else {return}
                        let uid = res["uid"] as! String
                        let id = res["tripID"] as! String
                        //self.time = res["time"] as! String
                        print(uid)
                        print(id)
                        if (uid == CurrentUser.UID)
                        {
                            if tripID == id
                            {
                                boolReturn = true
                            }
                        }
                    }
                }
            }
            if boolReturn == false
            {
                let alert = UIAlertController(title: "Booking Trip?".localized(), message: "Do you want to book this trip?".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (action) in
                    
                    request["chatId"] = ""
                    request["last_message"] = ""
                    request["tripID"] = userTripID
                    storageManager.ref?.child("User_Inbox").child(models[indexPath.row].uid).child("Inbox").child(tripID).child(CurrentUser.UID).setValue(request)
                    storageManager.ref.child("Taxi_Requests").child(CurrentUser.UID).child(userTripID).child("Pending_Requests").child(tripID).setValue(["status":"Pending"])
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "No".localized(), style: .default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: "You already sent your request".localized(), message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert,animated: true)
            }
        }
    }
    
    private func setUpView()
    {
        if self.matchFound == true
        {
            self.title = "Taxi Trips".localized()
        }
        else
        {
            let alert = UIAlertController(title: "We have received your request".localized(), message: "We will look for your match and notify you when we found one.".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"Okay".localized(),style: .default, handler:{( action) in
                alert.dismiss(animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    
    
    func sendTaxiRequest(completion: @escaping (String) -> ())
    {
        request = [
                       "uid":CurrentUser.UID,
                       "username":CurrentUser.Username,
                       "time":UserTaxiTripRequest.time,
                       "from":UserTaxiTripRequest.fromLocationName,
                       "fromLocationLat":UserTaxiTripRequest.fromCoordinateLat,
                       "fromLocationLong":UserTaxiTripRequest.fromCoordinateLong,
                       "to":UserTaxiTripRequest.toLocationName,
                       "toLocationLat":UserTaxiTripRequest.toCoordinateLat,
                        "toLocationLong":UserTaxiTripRequest.toCoordinateLong, "status": "Pending"] as [String:Any]
        storageManager.sendingTaxiRequestToFirebase(request: request,completion:{ tripID in
            completion(tripID)
        })
    }
   
    func matchRequest()
    {
        let group = DispatchGroup()
        group.enter()
        storageManager.findTripsForTaxiRequest(group: group) { dataTrip in
            let fromDistance = self.taxiTripRequestFromLocation.distance(from: dataTrip.dataFromLocation) / 1000
            print("fromDistance: " + String(fromDistance))
            let currentUserID = CurrentUser.UID
            if (currentUserID != dataTrip.uid)
            {
                if (fromDistance <= 3)
                {
                    print("inside from distance")
                    let toDistance = self.taxiTripRequestToLocation.distance(from: dataTrip.dataToLocation) / 1000
                    if (toDistance <= 3)
                    {
                        print("inside to distance")
                        let dataTime = myDateFormat.stringToDate(dataTrip.time)
                        let requestTime = myDateFormat.stringToDate(UserTaxiTripRequest.time)

                        if dataTime <= (requestTime.addingTimeInterval(60*120)) && dataTime >= requestTime
                        {
                            print("dates are matched")
                            let data = TaxiTripData(passengerName: dataTrip.username,uid:dataTrip.uid, fromLocation: dataTrip.from, toLocation: dataTrip.to, time: dataTrip.time)
                            self.taxiTrips.append(data)
                            print(self.taxiTrips[0])
                        }
                    
                    }
                }
            }
        }
        group.notify(queue: .main)
        {
            self.sortTrips()
            self.fillModelsArray()
            self.setUpView()
        }
    }
    
    func sortTrips()
    {
        if self.taxiTrips.isEmpty == false
        {
            print("match found")
            self.title = "Taxi Trips"
            var sortedRequests:[TaxiTripData] = []
            while self.taxiTrips.isEmpty == false
            {
                var date1 = myDateFormat.stringToDate(self.taxiTrips[0].time)
                var date1_index = 0
                if (self.taxiTrips.count != 1)
                {
                    for temp in 0...self.taxiTrips.count-1
                    {
                        let date2 = myDateFormat.stringToDate(self.taxiTrips[temp].time)
                        if date2 < date1
                        {
                           // print("date2 < date1 (date2: "+self.trips[temp].time+" date1: "+self.trips[date1_index].time)
                            date1_index = temp
                            date1 = date2
                        }
                    }
                }
                sortedRequests.append(self.taxiTrips[date1_index])
                while date1_index != self.taxiTrips.count-1
                {
                    self.taxiTrips[date1_index] = self.taxiTrips[date1_index+1]
                    date1_index+=1
                }
                let dummy = self.taxiTrips.popLast()
                
            }
            print(sortedRequests[0])
            self.taxiTrips = sortedRequests
            self.matchFound = true
        }
        else
        {
            print("no matches found. pending...")
        }
    }
    
    func fillModelsArray()
    {
        for i in taxiTrips
        {
            models.append(TripPost(driverName: i.passengerName, uid: i.uid, profilePicture: UIImage(named:"emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time, numberOfPassengers: 0, price: 0))
        }
        print(String(models.count))
        tableView.reloadData()
    }
}
