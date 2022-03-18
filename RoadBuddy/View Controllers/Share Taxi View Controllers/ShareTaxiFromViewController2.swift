//
//  ShareTaxiFromViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit

var UserTaxiTripRequest = TaxiTripRequest(fullname: CurrentUser.Fullname, uid: CurrentUser.UID)

class ShareTaxiFromViewController2: UIViewController, UISearchResultsUpdating
{
    let searchController = UISearchController(searchResultsController: ResultsVC())

    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "From where?".localized()
        navigationItem.backButtonTitle = "Back".localized()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

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
    



extension ShareTaxiFromViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String) {
        searchController.searchBar.text = address
        
        UserTaxiTripRequest.fromLocationName = address
        
        UserTaxiTripRequest.fromCoordinateLat = coordinates.latitude
        
        UserTaxiTripRequest.fromCoordinateLong = coordinates.longitude
        
        let shareMapVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchMapVC") as! SearchMapViewController
        
        shareMapVC.coordinates = coordinates
        
        shareMapVC.buttonAction =
        {
            let viewController = ShareTaxiToViewController2()
            viewController.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        shareMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(shareMapVC, animated: true)
    }
}


    


