//
//  Requests.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 9.02.2022.
//

import Foundation
import CoreLocation
import UIKit

class SearchTripRequest
{
    
    var time = String()
    
    var numberOfPassengers = Int()
    
    var fromLocationName = String()
    
    var toLocationName = String()
    
    var fromCoordinateLat = Double()
    
    var fromCoordinateLong = Double()
    
    var toCoordinateLat = Double()
    
    var toCoordinateLong = Double()
    
    func fetchData()
    {
        self.time = myDateFormat.dateToString(Date())
    }
}

class UserTripPost
{
    var fullname = String()
    
    var username = String()
    
    var uid = String()
    
    var profilePictureURL = String()
    
    var fromLocationName = String()
    
    var fromLocationLat = Double()
    
    var fromLocationLong = Double()
    
    var toLocationName = String()
    
    var toLocationLat = Double()
    
    var toLocationLong = Double()
    
    var time = String()
    
    var price = Int()
    
    var passengerNumber = Int()
    
    func fetchData()
    {
        self.uid = CurrentUser.UID
        
        self.username = CurrentUser.Username
        
        self.fullname = CurrentUser.Fullname
        
        self.profilePictureURL = CurrentUser.profilePictureURL
        
        self.time = myDateFormat.dateToString(Date())
    }
}


class TaxiTripRequest
{
    var fullname:String
    
    var uid:String
    
    var time =  myDateFormat.dateToString(Date())
    
    var fromLocationName = String()
    
    var toLocationName = String()
    
    var fromCoordinateLat = Double()
    
    var fromCoordinateLong = Double()
    
    var toCoordinateLat = Double()
    
    var toCoordinateLong = Double()
    
    init(fullname:String,uid:String)
    {
        self.fullname = fullname
        self.uid = uid
    }
}

class TripPost
{
    var driverName = String()
    
    var uid = String()
    
    var profilePicture = UIImage()
    
    var fromLocation = String()
    
    var toLocation = String()
    
    var time = String()
    
    var numberOfPassengers = Int()
    
    var price = Int()
    
    init(driverName: String, uid: String, profilePicture: UIImage, fromLocation: String, toLocation: String, time: String, numberOfPassengers: Int, price: Int)
    {
        self.driverName = driverName
        self.uid = uid
        self.profilePicture = profilePicture
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.time = time
        self.numberOfPassengers = numberOfPassengers
        self.price = price
    }
}

struct InboxObject
{
    var username:String
    
    var profilePictureURL:String
    
    var message:String
    
    var uid:String
    
    var status:String
    
    var tripID:String
}

