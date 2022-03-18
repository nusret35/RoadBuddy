//
//  SearchToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 11.02.2022.
//

import UIKit
import MapKit
import CoreLocation

class SearchToViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where to?".localized()
        navigationItem.backButtonTitle = "Back".localized()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    func updateSearchResults(for searchController: UISearchController) {
        let vc = searchController.searchResultsController as! ResultsVC
        vc.delegate = self
        if let text =
            searchController.searchBar.text,
           !text.isEmpty{
            LocationManager.shared.findLocations(with: text, mapView: MKMapView()){
                locations in
                DispatchQueue.main.async {
                    vc.updateData(locations)
                }
            }
        }
    }
    
}
extension SearchToViewController: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String)
    {
        //adding datas to request
        UserSearchTripRequest.toLocationName = address
        UserSearchTripRequest.toCoordinateLat = Double(coordinates.latitude)
        UserSearchTripRequest.toCoordinateLong = Double(coordinates.longitude)
        //setting up the view controller
        searchController.searchBar.text = address
        let searchMapVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchMapVC") as! SearchMapViewController

        searchMapVC.coordinates = coordinates
        //Setting navigation bar buttons
        navigationItem.backBarButtonItem = Buttons.defaultBackButton
        searchMapVC.buttonAction =
        {
            let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "SearchTimeVC") as! SearchTimeViewController
            
            vc.settingForSearch = true
            
            vc.settingForPost = false
            
            vc.settingForTaxi = false
            
            vc.view.backgroundColor = .systemBackground
            vc.navigationItem.backBarButtonItem = Buttons.defaultBackButton
            vc.title = "Set Time".localized()
            vc.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.pushViewController(vc, animated: true)
        }
        searchMapVC.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        //Setting navigation bar title
        //searchMapVC.title = address
        searchMapVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchMapVC, animated: true)
    }
    
}

class SearchMapToViewController: UIViewController
{
    let mapView = MKMapView()
    var coordinates = CLLocationCoordinate2D()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.backgroundColor = .systemBackground
        pinTheLocation()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.frame = CGRect(x:0,y:view.safeAreaInsets.top,width:view.frame.size.width,height: view.frame.size.height)
    }
    
    func pinTheLocation() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
    
}

