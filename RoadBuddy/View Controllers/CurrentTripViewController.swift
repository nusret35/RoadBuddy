//
//  CurrentTripViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 24.03.2022.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class CurrentTripViewController: UIViewController, CLLocationManagerDelegate{
    
    private let mapView = MKMapView()
    
    private var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    override func viewDidLayoutSubviews() {
        setUpSubViews()
    }
    
    func setUpSubViews()
    {
        mapView.frame = view.bounds
        view.addSubview(mapView)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    //mapView.showsUserLocation = true
                }
            }
        }
    }

}
