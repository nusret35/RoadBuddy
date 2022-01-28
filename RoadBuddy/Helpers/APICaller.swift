//
//  APICaller.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 16.12.2021.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import CoreLocation

struct Data
{
    var driverName:String
    
    var fromLocation:String
    
    var toLocation:String
    
    var price:String
    
    var time:String
    
    var numberOfPassengers:Int
    
    var uid:String
}

struct TaxiTripData
{
    var passengerName:String
    
    var uid:String
    
    var fromLocation:String
    
    var toLocation:String
    
    var time:String
    
}

class DataList
{
}

//bi class yap. arraySize için
class APICaller
{
    let ref = Database.database().reference()
    
    var datas: [Data] = []
    
   /* func  fetchData(fromLocation:CLLocation,toLocation:CLLocation) -> Void
    //swift tarzı yazman lazım!
    {
        print("inside fetch data")
        var trips:[Data] = []

        ref.child("Trips").observeSingleEvent(of: .value, with: { (snapshot)  in
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
                let numberOfPassengers = res["number of passengers"] as! String
                let fromLat = res["fromCoordinateLatitude"] as! Double
                let fromLong = res["fromCoordinateLongitude"] as! Double
                let toLat = res["toCoordinateLatitude"] as! Double
                let toLong = res["toCoordinateLongitude"] as! Double
                let dataFromLocation = CLLocation(latitude: fromLat, longitude: fromLong)
                let fromDistance = fromLocation.distance(from: dataFromLocation) / 1000
                print(fromDistance)
                if (fromDistance <= 8)
                {
                    print("inside from distance")
                    let dataToLocation = CLLocation(latitude: toLat, longitude: toLong)
                    let toDistance = toLocation.distance(from: dataToLocation) / 1000
                    print(toDistance)
                    if (toDistance <= 8)
                    {
                        print("inside to distance")
                        let data = Data(driverName: name, fromLocation: from, toLocation: to, price: price, time: time, numberOfPassengers: numberOfPassengers)
                        trips.append(data)
                        print(trips[0].driverName)
                        print(trips[0].time)
                    }
                }
            }
            self.datas = trips
            print(self.datas[0].driverName)
            print(self.datas[1].driverName)
        })
    } */
    
}
