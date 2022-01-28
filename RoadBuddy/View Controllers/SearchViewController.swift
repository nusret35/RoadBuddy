//
//  SearchViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 23.09.2021.
//

import UIKit
import MapKit
import CoreLocation



protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController ( _ vc:SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, title: String)
}

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: SearchViewControllerDelegate?
    
    let mapView = MKMapView()
    
    
    private let label:UILabel = {
        let label = UILabel()
        label.text = "Where To?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private let button:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: 10, width: 300, height: 50)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    @IBAction func ButtonActionSearchView(_ sender: Any) {
       /* let vc = FromWhereToViewController()
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()*/
        print("hello")
    }
    var window: UIWindow?
    
    @objc func buttonAction(sender: UIButton!){
        
        let vc = FromWhereToViewController()
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
         print("Button Tapped")
     }
    
    private let field: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter destination"
        field.layer.cornerRadius = 9
        field.backgroundColor = .tertiarySystemBackground
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        return field
    }()

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var locations = [Location]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(label)
        view.addSubview(field)
        view.addSubview(tableView)
        view.addSubview(button)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .secondarySystemBackground
        field.delegate = self
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 10, y: 10, width: label.frame.size.width, height: label.frame.size.height)
        field.frame = CGRect(x: 10, y: 20+label.frame.size.height, width: view.frame.size.width, height: 50)
        let tableY: CGFloat = field.frame.origin.y+field.frame.size.height+5
        tableView.frame = CGRect(x: 0, y: tableY, width: view.frame.size.width, height: view.frame.size.height-tableY)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        field.resignFirstResponder()
        if let text = field.text, !text.isEmpty{
            LocationManager.shared.findLocations(with: text, mapView: mapView){ [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?.tableView.reloadData()
                }
                }
            }
        
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = locations[indexPath.row].title
        cell.textLabel?.numberOfLines = 0
        cell.contentView.backgroundColor = .secondarySystemBackground
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Notify map controller to show pin at selected place
        let coordinate = locations[indexPath.row].coordinates
        let title = locations[indexPath.row].title
        print(coordinate)
        delegate?.searchViewController(self, didSelectLocationWith: coordinate, title: title)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       let footerView = UIView()
       footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:
       100)
       footerView.addSubview(button)
       return footerView
    }
    
}
