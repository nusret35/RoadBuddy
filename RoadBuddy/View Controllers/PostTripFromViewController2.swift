//
//  PostTripViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit

class PostTripFromViewController2: UIViewController, UISearchResultsUpdating{
    
    

    let searchController = UISearchController(searchResultsController: ResultsVC())

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "From where ?"
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
    



extension PostTripFromViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String) {
        searchController.searchBar.text = address
        
        let postMapVC = SearchMapViewController()
        postMapVC.coordinates = coordinates
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        
        navigationItem.backBarButtonItem = backButton
        
        let rightBarButton = UIBarButtonItem(image:
                                                UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(rightButtonAction))
        
        postMapVC.navigationItem.rightBarButtonItem = rightBarButton
        
        postMapVC.title = address
        postMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(postMapVC, animated: true)

    }
    
    @objc func rightButtonAction()
    {
        let viewController = PostTripToViewController2()
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(viewController, animated: true)
    }

}
