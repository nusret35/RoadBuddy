//
//  SearchFromViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 10.02.2022.
//

import UIKit
import MapKit
import CoreLocation


class ResultsVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    let tableView = UITableView()
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
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
}

class SearchFromViewController: UIViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: ResultsVC())
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Where are you?"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {

        let vc = searchController.searchResultsController as! ResultsVC
        if let text = searchController.searchBar.text, !text.isEmpty{
            LocationManager.shared.findLocations(with: text, mapView: MKMapView()){
                [weak self] locations in DispatchQueue.main.async{
                    self?.locations = locations
                    vc.locations = locations
                    vc.tableView.reloadData()
                }
            }
        }
        }
    }
    

