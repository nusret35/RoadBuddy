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

class CurrentTripViewController: UIViewController, CLLocationManagerDelegate, FloatingPanelControllerDelegate{
    
    private let mapView = MKMapView()
    
    private let manager = CLLocationManager()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUpFloatingPanel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest // battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    override func viewDidLayoutSubviews()
    {
        setUpSubViews()
    }
    
    func setUpSubViews()
    {
        mapView.frame = view.bounds
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
    }
    
    func setUpFloatingPanel()
    {
        let fpc = FloatingPanelController()
        let content_view = ContentViewController()
        fpc.delegate = self
        fpc.set(contentViewController: content_view)
        fpc.addPanel(toParent: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location:CLLocation)
    {
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinate
        
        print(String(location.coordinate.latitude))
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        
        mapView.addAnnotation(pin)
    }
    
}
