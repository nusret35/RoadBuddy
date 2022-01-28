//
//  TaxiResultViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 24.01.2022.
//

import UIKit
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
import FirebaseStorage

class TaxiResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var driverNameLabel: UILabel!
    
    @IBOutlet weak var fromLocationLabel: UILabel!
    
    @IBOutlet weak var toLocationLbel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var models = [TaxiTripPost]()
    
    var datas: [TaxiTripData] = []
    
    let ref = Database.database().reference()
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        table.register(TaxiTableViewCell.nib(), forCellReuseIdentifier: TaxiTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        SetUpElements()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("models count: " + String(self.models.count))
        return self.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaxiTableViewCell.identifier, for: indexPath) as! TaxiTableViewCell
        cell.configure(with: self.models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 427
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrip = models[indexPath.row]
        createAlert(title: "Booking Taxi Trip", message: "You are booking a taxi trip.")
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func SetUpElements()
    {
        var trips:[TaxiTripData] = []

        ref.child("Taxi_Trips").observeSingleEvent(of: .value, with: { (snapshot)  in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any] else {return}
                let name = res["fullname"] as! String
                print(name)
                let uid = res["uid"] as! String
                let from = res["from"] as! String
                let to = res["to"] as! String
                let time = res["time"] as! String
                let fromLat = res["fromCoordinateLatitude"] as! Double
                let fromLong = res["fromCoordinateLongitude"] as! Double
                let toLat = res["toCoordinateLatitude"] as! Double
                let toLong = res["toCoordinateLongitude"] as! Double
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                let fromDistance = SearchFromLocation.distance(from: dataFromLocation) / 1000
                guard let currentUserID = Auth.auth().currentUser?.uid else
                {
                    print("user not found")
                    return
                }
                if (currentUserID != uid)
                {
                    if (fromDistance <= 8)
                    {
                        let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                        let toDistance = SearchToLocation.distance(from: dataToLocation) / 1000
                        if (toDistance <= 8)
                        {
                            let data = TaxiTripData(passengerName:name,
                                                    uid:uid,fromLocation: from, toLocation: to, time: time)
                            trips.append(data)
                            print(trips[0].passengerName)
                        }
                    }
                }
            }
            self.datas = trips
            for i in self.datas
            {
                self.models.append(TaxiTripPost(username: i.passengerName,uid:i.uid,profilePicture: UIImage(named: "emptyProfilePicture")!, fromLocation: i.fromLocation, toLocation: i.toLocation, time: i.time))
            }
            self.table.reloadData()
            
        })
        
    }
    
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Book", style: UIAlertAction.Style.default, handler: { [self] (action) in
            //add actions: send message to the post owner
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated:true, completion: nil)
    }
    
}

struct TaxiTripPost
{
    let username: String
    let uid: String
    let profilePicture: UIImage
    let fromLocation: String
    let toLocation: String
    let time: String
}
