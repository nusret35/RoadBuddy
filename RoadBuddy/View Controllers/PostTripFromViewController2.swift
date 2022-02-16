//
//  PostTripViewController2.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-11.
//

import UIKit
import MapKit

var CurrentUserTripPost = UserTripPost()

class PostTripFromViewController2: UIViewController, UISearchResultsUpdating
{
    
    let searchController = UISearchController(searchResultsController: ResultsVC())

    override func viewDidLoad()
    {
        super.viewDidLoad()
        fillUserDataToPost()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where are you?".localized()
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
    
    func fillUserDataToPost()
    {
        CurrentUserTripPost.fullname = CurrentUser.Fullname

        CurrentUserTripPost.username = CurrentUser.Username

        CurrentUserTripPost.uid = CurrentUser.UID

        CurrentUserTripPost.profilePictureURL = CurrentUser.profilePictureURL
    }
}
    


extension PostTripFromViewController2: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String) {
        
        CurrentUserTripPost.fromLocationName = address
        
        CurrentUserTripPost.fromLocationLat = coordinates.latitude
        
        CurrentUserTripPost.fromLocationLong = coordinates.longitude
        
        searchController.searchBar.text = address
        
        let postMapVC = SearchMapViewController()
        
        postMapVC.coordinates = coordinates
        
        //NEW ADDED
        let action = #selector(rightButtonAction)
        
        let rightBarButton = Buttons.createDefaultRightButton(self,action)

        postMapVC.navigationItem.rightBarButtonItem = rightBarButton
        
        postMapVC.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        
        postMapVC.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationController?.pushViewController(postMapVC, animated: true)

    }
    
    @objc func rightButtonAction()
    {
        let viewController = PostTripToViewController2()
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }

}
