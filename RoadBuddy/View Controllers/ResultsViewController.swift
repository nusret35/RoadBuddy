//
//  ResultsViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 1.10.2021.
//

import UIKit
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import FirebaseStorage

var DriverUID = ""

var SeatsAvaliable = 0

var SeatsList = [String]()

class ResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource //,PostTableViewCellDelegate
{
    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var fromLocationLabel: UILabel!
    
    @IBOutlet weak var toLocationLbel: UILabel!
    
    @IBOutlet weak var taxiTripSearchButton: UIBarButtonItem!
    
    
    @IBOutlet weak var table: UITableView!
    
    var models = [TripPost]()
    
    var datas: [DriverData] = []
    
    let ref = Database.database().reference()
    
    lazy var bookTripViewController = storyboard?.instantiateViewController(withIdentifier: "BookTripVC") as! BookTripViewController
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        SetUpElements()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("models count: " + String(self.models.count))
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        //cell.cellDelegate = self
        cell.configure(with: self.models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 427
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = models[indexPath.row]
        DriverUID = selectedTrip.uid
        ref.child("Trips").child(DriverUID).observeSingleEvent(of: .value) { [self] (snapshot) in
            guard let res = snapshot.value as? [String:Any] else {return}
            SeatsAvaliable = res["number of passengers"] as! Int
            print(SeatsAvaliable)
            print("driverUID: " + DriverUID)
            var i = 1
            while (i <= SeatsAvaliable)
            {
                SeatsList.append(String(i))
                i+=1
            }
            present(bookTripViewController, animated: true, completion: nil)
        }
    }
    
    /*
    func didPressButton()
    {
        let bookTripViewController = storyboard?.instantiateViewController(withIdentifier: "BookTripVC") as! BookTripViewController
        present(bookTripViewController, animated: true, completion: nil)
    }*/
    
    

    func SetUpElements()
    {
        var trips:[DriverData] = []

        ref.child("Trips").observeSingleEvent(of: .value, with: { (snapshot)  in
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
                let fromDistance = SearchFromLocation.distance(from: dataFromLocation) / 1000
                guard let currentUserID = Auth.auth().currentUser?.uid else
                {
                    print("user not found")
                    return
                }
                if (currentUserID != dUID)
                {
                    if (fromDistance <= 8)
                    {
                        print("inside from distance")
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = SearchToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 8)
                        {
                            print("inside to distance")
                            let data = DriverData(driverName: name, fromLocation: from, toLocation: to, price: price, time: time, numberOfPassengers: numberOfPassengers,uid:dUID)
                            trips.append(data)
                            print(trips[0].driverName)
                        }
                    }
                }
            }
            self.datas = trips
            for i in self.datas
            {
                print(i.driverName)
                self.models.append(TripPost(username: i.driverName, uid:i.uid, profilePicture: UIImage(named: "emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time, numberOfPassengers: i.numberOfPassengers, price: i.price))
            }
            self.table.reloadData()
            
        })
        
    }
    
    
    
}

struct TripPost
{
    let username: String
    let uid:String
    let profilePicture: UIImage
    let fromLocation: String
    let toLocation: String
    let time: String
    let numberOfPassengers: Int
    let price: Int
}
