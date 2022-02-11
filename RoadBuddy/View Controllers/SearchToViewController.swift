//
//  SearchToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 11.02.2022.
//

import UIKit
import MapKit
import CoreLocation
import SwiftUI

class SearchToViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where to?"
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
        searchController.searchBar.text = address
        let searchMapVC = SearchMapViewController()

        searchMapVC.coordinates = coordinates
        //Setting navigation bar buttons
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        //right bar button action
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(rightButtonAction))
        searchMapVC.navigationItem.rightBarButtonItem = rightBarButton
        //Setting navigation bar title
        searchMapVC.title = address
        searchMapVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchMapVC, animated: true)
    }
    
    @objc func rightButtonAction()
    {
        navigationController?.pushViewController(FirstViewController(), animated: true)
    }

}

