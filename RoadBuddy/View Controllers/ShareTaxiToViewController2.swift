//
//  ShareTaxiToViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit

class ShareTaxiToViewController2: UIViewController, UISearchResultsUpdating
{
    let searhController = UISearchController(searchResultsController: ResultsVC())
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where will you go?".localized()
        navigationItem.backButtonTitle = "Back".localized()
        searhController.searchResultsUpdater = self
        navigationItem.searchController = searhController
        
  
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        let ViewController = searchController.searchResultsController as! ResultsVC
        ViewController.delegate = self
        if let text = searchController.searchBar.text, !text.isEmpty
        {
            LocationManager.shared.findLocations(with: text, mapView: MKMapView())
            {
                locations in DispatchQueue.main.async
                {
                    
                        ViewController.updateData(locations)
                    }
                }
            }
    }
    
}

extension ShareTaxiToViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String)
    {
        searhController.searchBar.text = address
    
        UserTaxiTripRequest.toLocationName = address
        
        UserTaxiTripRequest.toCoordinateLat = coordinates.latitude
        
        UserTaxiTripRequest.toCoordinateLong = coordinates.longitude
        
        let shareMapVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchMapVC") as! SearchMapViewController
        
        shareMapVC.coordinates = coordinates
        
        shareMapVC.buttonAction =
        {
            let viewController = self.mainStoryboard.instantiateViewController(withIdentifier: "SearchTimeVC") as! SearchTimeViewController
            
            viewController.settingForTaxi = true
            
            viewController.settingForPost = false
            
            viewController.settingForSearch = false
            
            viewController.view.backgroundColor = .systemBackground
            
            viewController.navigationItem.backBarButtonItem = Buttons.defaultBackButton
            
            viewController.title = "Set Time".localized()
            
            viewController.navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back".localized()
        
        navigationItem.backBarButtonItem = backButton
        
        //ShareMapVC.title = address
        shareMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(shareMapVC, animated: true)

    }
    

}
