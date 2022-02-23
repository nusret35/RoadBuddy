//
//  SearchMatchRequestViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 13.02.2022.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation

class SearchMatchRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    //View Elements
    private let tableView:UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    
    
    //Request array elements
    private var request = [String:Any]()
    
    private var searchFromLocation = CLLocation()
    
    private var searchToLocation = CLLocation()
    
    private var trips:[DriverData] = []
    
    private var models = [TripPost]()
    
    private var requestFound = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        sendTheRequest()
        matchRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    //SETTING OF VIEW ELEMENTS
    private func setUpView()
    {
        if self.requestFound == true
        {
            self.title = "Trips".localized()
            self.setUpTableView()
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
    
    
    private func setUpTableView()
    {
        tableView.isHidden = false
        tableView.backgroundColor = .systemBackground
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    //TABLEVIEW FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.configure(with: self.models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 270
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var boolReturn = false
        
        storageManager.ref.child("User_Inbox").child(models[indexPath.row].uid).child("request").observeSingleEvent(of: .value) { [self] snapshot in
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
                    storageManager.ref?.child("User_Inbox").child(models[indexPath.row].uid).child("request").child(CurrentUser.UID).setValue(request)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return myDateFormat.takeDayFromStringDate(UserSearchTripRequest.time)
    }
    

    
    
    
    //SETTING OF REQUEST ELEMENTS
    func sendTheRequest()
    {
        self.request  = ["requestAccepted":false,"requestPending":true,"uid":CurrentUser.UID,"username":CurrentUser.Username] as [String : Any]u
        storageManager.ref.child("Search_Requests").child(CurrentUser.UID).setValue(self.request)
        searchFromLocation = CLLocation(latitude: UserSearchTripRequest.fromCoordinateLat, longitude: UserSearchTripRequest.fromCoordinateLong)
        searchToLocation = CLLocation(latitude: UserSearchTripRequest.toCoordinateLat, longitude: UserSearchTripRequest.toCoordinateLong)
    }
    
    
    func matchRequest()
    {
        storageManager.db.collection("users").document(CurrentUser.UID).updateData(["lookingForATrip":true])
        storageManager.ref.child("Trips")
            .observeSingleEvent(of: .value, with: { [self] (snapshot)  in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let name = res["fullname"] as! String
                print(name)
                let from = res["from"] as! String
                let to = res["to"] as! String
                let price = res["price"] as! Int
                let time = res["time"] as! String
                let numberOfPassengers = res["number of passengers"] as! Int
                let fromLat = res["fromCoordinateLatitude"] as! Double
                let fromLong = res["fromCoordinateLongitude"] as! Double
                let toLat = res["toCoordinateLatitude"] as! Double
                let toLong = res["toCoordinateLongitude"] as! Double
                let dUID = res["uid"] as! String
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                
                let fromDistance = self.searchFromLocation.distance(from: dataFromLocation) / 1000
                print("searchFromLat: " + String(self.searchFromLocation.coordinate.latitude))
                print("searchFromLong: " +  String(self.searchFromLocation.coordinate.longitude))
                print("searchToLat: " + String(self.searchToLocation.coordinate.latitude))
                print("searchToLong: " + String(self.searchToLocation.coordinate.longitude))
                print("fromDistance: " + String(fromDistance))
                let currentUserID = CurrentUser.UID
                if (currentUserID != dUID)
                {
                    if (fromDistance <= 8)
                    {
                        print("inside from distance")
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = self.searchToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 8)
                        {
                            print("inside to distance")
                            if (UserSearchTripRequest.numberOfPassengers <= numberOfPassengers)
                            {
                                print("passengers found")
                                let dataTime = myDateFormat.stringToDate(time)
                                let requestTime = myDateFormat.stringToDate(UserSearchTripRequest.time)
            
                                if dataTime <= (requestTime.addingTimeInterval(60*120)) && dataTime >= requestTime
                                {
                                    print("dates are matched")
                                    let data = DriverData(driverName: name, fromLocation: from, toLocation: to, price: price, time: time, numberOfPassengers: numberOfPassengers,uid:dUID)
                                    self.trips.append(data)
                                    print(self.trips[0].driverName)
                                }
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
        if self.trips.isEmpty == false
        {
            print("match found")
            self.title = "Trips"
            var sortedRequests:[DriverData] = []
            while self.trips.isEmpty == false
            {
                var date1 = myDateFormat.stringToDate(self.trips[0].time)
                var date1_index = 0
                if (self.trips.count != 1)
                {
                    for temp in 0...self.trips.count-1
                    {
                        let date2 = myDateFormat.stringToDate(self.trips[temp].time)
                        if date2 < date1
                        {
                            print("date2 < date1 (date2: "+self.trips[temp].time+" date1: "+self.trips[date1_index].time)
                            date1_index = temp
                            date1 = date2
                        }
                    }
                }
                sortedRequests.append(self.trips[date1_index])
                while date1_index != self.trips.count-1
                {
                    self.trips[date1_index] = self.trips[date1_index+1]
                    date1_index+=1
                }
                let dummy = self.trips.popLast()
                
            }
            print(sortedRequests[0])
            self.trips = sortedRequests
            self.requestFound = true
        }
        else
        {
            print("no matches found. pending...")
        }
    }
    
    func fillModelsArray()
    {
        for i in self.trips
        {
            self.models.append(TripPost(driverName: i.driverName, uid: i.uid, profilePicture: UIImage(named:"emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time, numberOfPassengers: i.numberOfPassengers, price: i.price))
        }
        print(String(models.count))
        self.tableView.reloadData()
    }

}
