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
    
    private let taxiTripRequestFromLocation = CLLocation(latitude: UserTaxiTripRequest.fromCoordinateLat, longitude: UserTaxiTripRequest.fromCoordinateLong)
    
    private let taxiTripRequestToLocation = CLLocation(latitude: UserTaxiTripRequest.toCoordinateLat, longitude: UserTaxiTripRequest.toCoordinateLong)
    
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
        
        storageManager.ref.child("User_Inbox").child(models[indexPath.row].uid).observeSingleEvent(of: .value) { [self] snapshot in
            if snapshot.exists() == true
            {
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else {return}
                    let uid = res["uid"] as! String
                    print(uid)
                    if (uid == CurrentUser.UID)
                    {
                        boolReturn = true
                    }
                }
            }
            if boolReturn == false
            {
                let alert = UIAlertController(title: "Booking Trip?".localized(), message: "Do you want to book this trip?".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { (action) in
                    storageManager.ref?.child("User_Inbox").child(models[indexPath.row].uid).child(CurrentUser.UID).setValue(self.request)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setUpTableView()
        sendTaxiRequest()
        matchRequest()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
    
    
    
    func sendTaxiRequest()
    {
        self.request = ["fullname":CurrentUser.Fullname,
                       "uid":CurrentUser.UID,
                       "time":UserTaxiTripRequest.time,
                       "from":UserTaxiTripRequest.fromLocationName,
                       "fromLocationLat":UserTaxiTripRequest.fromCoordinateLat,
                       "fromLocationLong":UserTaxiTripRequest.fromCoordinateLong,
                       "to":UserTaxiTripRequest.toLocationName,
                       "toLocationLat":UserTaxiTripRequest.toCoordinateLat,
                       "toLocationLong":UserTaxiTripRequest.toCoordinateLong] as [String:Any]
        storageManager.ref.child("Taxi_Requests").child(CurrentUser.UID).setValue(request)
    }
   
    func matchRequest()
    {
        storageManager.db.collection("users").document(CurrentUser.UID).updateData(["lookingForATaxiTrip":true])
        storageManager.ref.child("Taxi_Requests")
            .observeSingleEvent(of: .value, with: { [self] (snapshot)  in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let name = res["fullname"] as! String
                print(name)
                let from = res["from"] as! String
                let to = res["to"] as! String
                let time = res["time"] as! String
                let fromLat = res["fromLocationLat"] as! Double
                let fromLong = res["fromLocationLong"] as! Double
                let toLat = res["toLocationLat"] as! Double
                let toLong = res["toLocationLong"] as! Double
                let dUID = res["uid"] as! String
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                
                let fromDistance = self.taxiTripRequestFromLocation.distance(from: dataFromLocation) / 1000
                print("fromDistance: " + String(fromDistance))
                let currentUserID = CurrentUser.UID
                if (currentUserID != dUID)
                {
                    if (fromDistance <= 3)
                    {
                        print("inside from distance")
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = self.taxiTripRequestToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 3)
                        {
                            print("inside to distance")
                            let dataTime = myDateFormat.stringToDate(time)
                            let requestTime = myDateFormat.stringToDate(UserTaxiTripRequest.time)
    
                            if dataTime <= (requestTime.addingTimeInterval(60*120)) && dataTime >= requestTime
                            {
                                print("dates are matched")
                                let data = TaxiTripData(passengerName: name,uid:dUID, fromLocation: from, toLocation: to, time: time)
                                self.taxiTrips.append(data)
                                print(self.taxiTrips[0])
                            }
                        
                        }
                    }
                }
            }
            self.sortTrips()
            self.fillModelsArray()
            self.setUpView()
        })
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
        for i in self.taxiTrips
        {
            self.models.append(TripPost(driverName: i.passengerName, uid: i.uid, profilePicture: UIImage(named:"emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time, numberOfPassengers: 0, price: 0))
        }
        print(String(models.count))
        self.tableView.reloadData()
    }
}
