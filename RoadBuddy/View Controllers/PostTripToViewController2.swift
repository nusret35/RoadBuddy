//
//  PostTripToViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit
import CoreLocation

class PostTripToViewController2: UIViewController, UISearchResultsUpdating
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

extension PostTripToViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String)
    {
        CurrentUserTripPost.toLocationName = address
        
        CurrentUserTripPost.toLocationLat = coordinates.latitude
        
        CurrentUserTripPost.toLocationLong = coordinates.longitude
        
        searhController.searchBar.text = address
    
        let postMapVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchMapVC") as! SearchMapViewController
        
        postMapVC.coordinates = coordinates
        
        postMapVC.buttonAction =
        {
            let viewController = self.mainStoryboard.instantiateViewController(withIdentifier: "SearchTimeVC") as! SearchTimeViewController
            
            viewController.view.backgroundColor = .systemBackground
            
            viewController.settingForPost = true
            
            viewController.settingForSearch = false
            
            viewController.settingForTaxi = false
            
            viewController.navigationItem.backBarButtonItem = Buttons.defaultBackButton
            viewController.title = "Set Time".localized()
            
            viewController.navigationItem.largeTitleDisplayMode = .always
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        postMapVC.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        
        
        postMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(postMapVC, animated: true)
    }
}
