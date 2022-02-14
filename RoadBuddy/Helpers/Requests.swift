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

