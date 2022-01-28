//
//  LocationManager.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 23.09.2021.
//

import Foundation
import CoreLocation
import MapKit

struct Location {
    let title: String
    let coordinates: CLLocationCoordinate2D
}


class LocationManager: NSObject {
    static let shared = LocationManager()
    
    public func findLocations(with query: String, mapView: MKMapView, completion: @escaping(([Location]) -> Void)) {
           let request = MKLocalSearch.Request()
               request.naturalLanguageQuery = query
               request.region = mapView.region
               let search = MKLocalSearch(request: request)
               search.start { response, _ in
                   
                   guard let response = response else {
                       return
                   }
                   
                   let matchingItems = response.mapItems
                   
                   var locations = [Location]()
                   
                   /// Iterate the list of matching items to form a list of Location
                   for item in matchingItems {
                       
                       let newLocation = Location(title: (item.name ?? "?") + " / " + (item.placemark.title ?? "?"), coordinates: item.placemark.coordinate)
                       
                       locations.append(newLocation)
                       
                   }
                   
                   /// Call completion method
                   completion(locations)
                   
               }

       }
/*   public func findCoreLocations(with query: String, completion: @escaping (([Location]) -> Void)){
        let geoCoder = CLGeocoder()
    
        var corelocations = [Location]()
        
        geoCoder.geocodeAddressString(query) { places, error in
            guard let places = places, error == nil else {
                completion([])
                return
            }
            
            let models: [Location] = places.compactMap ({ place in
                var name = ""
                if let locationName = place.name {
                    name += locationName
                }
                
                if let adminRegion = place.administrativeArea {
                    name += ", \(adminRegion)"
                }
                
                if let locality = place.locality {
                    name += ", \(locality)"
                }
                
                if let country = place.country {
                    name += ", \(country)"
                }
                
                print("\n\(place)\n\n")
                
                let result = Location(
                    title: name,
                    coordinates: place.location!.coordinate
                )
                
                corelocations.append(result)
                return result
            })
            completion(models)
        }
    } */
}
