//
//  Requests.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 9.02.2022.
//

import Foundation
import CoreLocation

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


struct TaxiTripRequest
{
    var fullname:String
    
    var uid:String
    
    var time:String
    
    var fromLocationName:String
    
    var toLocationName:String
    
    var fromCoordinateLat:Double
    
    var fromCoordinateLong:Double
    
    var toCoordinateLat:Double
    
    var toCoordinateLong:Double
}

