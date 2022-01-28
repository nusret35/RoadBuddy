//
//  ViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 23.09.2021.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation


class ViewController: UIViewController, SearchViewControllerDelegate {
    
    @IBOutlet weak var Button: UIBarButtonItem!
    let mapView = MKMapView()
    let panel = FloatingPanelController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        title = "RoadBuddy"
        let searchVC = SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        view.isUserInteractionEnabled = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, title:String) {
       
        let coordinates = coordinates
        
        
        panel.move(to: .tip, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates,
                                             span: MKCoordinateSpan(
                                                latitudeDelta: 0.7,
                                                longitudeDelta: 0.7
                                             )
        ),
        animated: true)
        
    }
}

