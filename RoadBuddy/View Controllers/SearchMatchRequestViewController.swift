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

class SearchMatchRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //View Elements
    private let tableView:UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        return table
    }()
    
    private let noTripsLabel:UILabel =
    {
        let label = UILabel()
        label.text = "We took your request. We will inform you when we find a trip."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
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
        view.addSubview(tableView)
        view.addSubview(noTripsLabel)
        sendTheRequest()
        matchRequest()
        setUpView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //SETTING OF VIEW ELEMENTS
    private func setUpView()
    {
        if requestFound
        {
            setUpTableView()
        }
        else
        {
            setUpLabel()
        }
    }
    
    
    private func setUpTableView()
    {
        tableView.backgroundColor = .systemBackground
        tableView.isHidden = false
        tableView.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpLabel()
    {
        noTripsLabel.isHidden = false
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
        return 427
    }
    
    
    
    
    //SETTING OF REQUEST ELEMENTS
    func sendTheRequest()
    {
        self.request  = ["fullname": CurrentUser.Fullname, "uid": CurrentUser.UID, "time": UserSearchTripRequest.time ,"number of passengers": UserSearchTripRequest.numberOfPassengers, "fromLocationName": UserSearchTripRequest.fromLocationName, "toLocationName": UserSearchTripRequest.toLocationName, "fromCoordinateLat": UserSearchTripRequest.fromCoordinateLat,"fromCoordinateLong": UserSearchTripRequest.fromCoordinateLong, "toCoordinateLat": UserSearchTripRequest.toCoordinateLat, "toCoordinateLong":
            UserSearchTripRequest.toCoordinateLong] as [String : Any]
        storageManager.ref.child("Requests").child(CurrentUser.UID).setValue(self.request)
        searchFromLocation = CLLocation(latitude: UserSearchTripRequest.fromCoordinateLat, longitude: UserSearchTripRequest.fromCoordinateLong)
        searchToLocation = CLLocation(latitude: UserSearchTripRequest.toCoordinateLat, longitude: UserSearchTripRequest.toCoordinateLong)
    }
    
    
    func matchRequest()
    {

        storageManager.ref.child("Trips")
        .observeSingleEvent(of: .value, with: { (snapshot)  in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let name = res["fullname"] as! String
                print(name)
                let from = res["from"] as! String
                let to = res["to"] as! String
                let price = res["price"] as! String
                let time = res["time"] as! String
                let numberOfPassengers = res["number of passengers"] as! Int
                let fromLat = res["fromCoordinateLatitude"] as! Double
                let fromLong = res["fromCoordinateLongitude"] as! Double
                let toLat = res["toCoordinateLatitude"] as! Double
                let toLong = res["toCoordinateLongitude"] as! Double
                let dUID = res["uid"] as! String
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                
                let fromDistance = self.searchFromLocation.distance(from: dataFromLocation) / 1000
                let currentUserID = CurrentUser.UID
                if (currentUserID != dUID)
                {
                    if (fromDistance <= 8)
                    {
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = self.searchToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 8)
                        {
                            if (UserSearchTripRequest.numberOfPassengers <= numberOfPassengers)
                            {
                                let dataTime = myDateFormat.stringToDate(time)
                                let requestTime = myDateFormat.stringToDate(UserSearchTripRequest.time)
            
                                if dataTime <= (requestTime.addingTimeInterval(60*120)) && dataTime >= requestTime
                                {
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
            
            
        })
        
    }
    
    func sortTrips()
    {
        if self.trips.isEmpty == false
        {
            print("match found")
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
            self.models.append(TripPost(username: i.driverName, uid: i.uid, profilePicture: UIImage(named:"emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time, numberOfPassengers: i.numberOfPassengers, price: i.price))
        }
        self.tableView.reloadData()
    }

}
