//
//  PostTripToViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class PostTripToViewController2: UIViewController, UISearchResultsUpdating
{
    
    let searhController = UISearchController(searchResultsController: ResultsVC())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where will you go ?"
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
        searhController.searchBar.text = address
        
        let postMapVC = SearchMapViewController()
        postMapVC.coordinates = coordinates
        
        //NEW ADDED
        let action = #selector(rightButtonAction)
        postMapVC.navigationItem.rightBarButtonItem = Buttons.createDefaultRightButton(self,action)
        postMapVC.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        //
        
        postMapVC.title = address
        postMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(postMapVC, animated: true)
    }
    
    @objc func rightButtonAction()
    {
        navigationController?.pushViewController(FirstViewController(), animated: true)
    }
}
