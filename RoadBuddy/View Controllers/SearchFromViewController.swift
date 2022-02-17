//
//  SearchFromViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 10.02.2022.
//

import UIKit
import MapKit
import CoreLocation

//create the request
var UserSearchTripRequest = SearchTripRequest()

protocol ResultsVCDelegate: AnyObject {
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String)
}

class ResultsVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    weak var delegate:ResultsVCDelegate?
    
    private let tableView = UITableView()
    
    var locations = [Location]()
    
    var vc = UIViewController()
    
    var selectedLocation = CLLocationCoordinate2D()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func updateData(_ locArray: [Location])
    {
        self.tableView.isHidden = false
        self.locations = locArray
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = locations[indexPath.row].title
            cell.textLabel?.numberOfLines = 0
            cell.contentView.backgroundColor = .secondarySystemBackground
            cell.backgroundColor = .secondarySystemBackground
            print(String(locations.count))
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        let selectedCoordinates = locations[indexPath.row].coordinates
        self.selectedLocation = selectedCoordinates
        let locationName = locations[indexPath.row].title
        self.delegate?.didTapPlace(with: selectedCoordinates, address: locationName)
    }
}


class SearchFromViewController: UIViewController, UISearchResultsUpdating {
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        UserSearchTripRequest.fetchData()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where are you?".localized()
        navigationItem.backButtonTitle = "Back".localized()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {

        let vc = searchController.searchResultsController as! ResultsVC
        vc.delegate = self
        if let text = searchController.searchBar.text, !text.isEmpty
        {
            LocationManager.shared.findLocations(with: text, mapView: MKMapView())
            {
                locations in DispatchQueue.main.async
                {
                    vc.updateData(locations)
                }
            }
        }
        }
    }
extension SearchFromViewController: ResultsVCDelegate
{
    func didTapPlace(with coordinates: CLLocationCoordinate2D, address: String) {
        searchController.searchBar.text = address
        //Add from address and coordinates to request
        UserSearchTripRequest.fromLocationName = address
        UserSearchTripRequest.fromCoordinateLat = Double(coordinates.latitude)
        UserSearchTripRequest.fromCoordinateLong = Double(coordinates.longitude)
        //Setting the next map view controller
        let searchMapVC = mainStoryboard.instantiateViewController(withIdentifier: "SearchMapVC") as! SearchMapViewController
        searchMapVC.coordinates = coordinates
        searchMapVC.buttonAction = {
            let vc = SearchToViewController()
            vc.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.pushViewController(vc, animated: true)
        }
        searchMapVC.navigationItem.backBarButtonItem = Buttons.defaultBackButton
        //Setting navigation bar title
        searchMapVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.pushViewController(searchMapVC, animated: true)
    }

}

/*
class SearchMapViewController: UIViewController
{
    @IBOutlet weak var mapView: MKMapView!
    //let mapView = MKMapView()
    var coordinates = CLLocationCoordinate2D()
    
    @IBOutlet weak var continueButton: UIButton!
    
    
    var buttonAction: ( () -> () )?
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //view.addSubview(mapView)
        view.backgroundColor = .systemBackground
        pinTheLocation()
    }
    
    
    @IBAction func continueButton(_ sender: Any)
    {
        buttonAction!()
    }
    
    
    func pinTheLocation()
    {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
    
    
}

*/
