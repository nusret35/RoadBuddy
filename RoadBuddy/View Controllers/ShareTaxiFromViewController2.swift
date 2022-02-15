//
//  ShareTaxiFromViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit

class ShareTaxiFromViewController2: UIViewController, UISearchResultsUpdating
{
    

    let searchController = UISearchController(searchResultsController: ResultsVC())

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
        
        let ShareMapVC = SearchMapViewController()
        ShareMapVC.coordinates = coordinates
        
        
        
        let rightBarButton = UIBarButtonItem(image:
                                                UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(rightButtonAction))
        
        ShareMapVC.navigationItem.rightBarButtonItem = rightBarButton
        
        //ShareMapVC.title = address
        ShareMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(ShareMapVC, animated: true)

    }
    
    @objc func rightButtonAction()
    {
        let viewController = ShareTaxiToViewController2()
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(viewController, animated: true)
    }

}


    


