//
//  SearchFromViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 10.02.2022.
//

import UIKit
import MapKit
import CoreLocation

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
    
    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Where are you?"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {

        let vc = searchController.searchResultsController as! ResultsVC
        vc.delegate = self
        if let text = searchController.searchBar.text, !text.isEmpty{
            LocationManager.shared.findLocations(with: text, mapView: MKMapView()){
                locations in DispatchQueue.main.async{
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
        //Setting the next map view controller
        let searchMapVC = SearchMapFromViewController()
        searchMapVC.coordinates = coordinates
        //Setting navigation bar buttons
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        navigationItem.backBarButtonItem = backButton
        //right bar button setting
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(rightButtonAction))
        searchMapVC.navigationItem.rightBarButtonItem = rightBarButton
        //Setting navigation bar title
        searchMapVC.title = address
        searchMapVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(searchMapVC, animated: true)
    }
    
    @objc func rightButtonAction()
    {
        let vc = SearchToViewController()
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
    }

}

class SearchMapFromViewController: UIViewController
{
    let mapView = MKMapView()
    var coordinates = CLLocationCoordinate2D()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.addSubview(mapView)
        pinTheLocation()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.frame = CGRect(x:0,y:view.safeAreaInsets.top,width:view.frame.size.width,height: view.frame.size.height)
    }
    
    func pinTheLocation() {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)), animated: true)
    }
    
    
}


