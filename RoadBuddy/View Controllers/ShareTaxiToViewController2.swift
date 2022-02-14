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

extension ShareTaxiToViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String) {
        searhController.searchBar.text = address
        
        let ShareMapVC = SearchMapViewController()
        ShareMapVC.coordinates = coordinates
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        
        navigationItem.backBarButtonItem = backButton
        
        let rightBarButton = UIBarButtonItem(image:
                                                UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(rightButtonAction))
        
        ShareMapVC.navigationItem.rightBarButtonItem = rightBarButton
        
        ShareMapVC.title = address
        ShareMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(ShareMapVC, animated: true)

    }
    
    
    @objc func rightButtonAction()
    {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: "SearchTimeVC") as! SearchTimeViewController
        
        viewController.view.backgroundColor = .systemBackground
        
        viewController.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        
        viewController.title = "Set Time"
        
        viewController.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.pushViewController(viewController, animated: true)
    }

}
