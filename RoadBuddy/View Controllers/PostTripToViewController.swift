//
//  PostTripToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 5.10.2021.
//

import UIKit
import CoreLocation
import MapKit
import FloatingPanel

protocol PostTripToViewControllerDelegate:AnyObject {
    func postTripToViewControlle(_ vc: PostTripToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String )
}

var ptToLatitude:Double = 0.0

var ptToLongitude:Double = 0.0

class PostTripToViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var MapView: MKMapView!
    
    @IBOutlet weak var ToLabel: UILabel!
    
    @IBOutlet weak var TextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    let panel = FloatingPanelController()

    var locations = [Location]()
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)

    var locname: String! = "Choose a location..."
    
    weak var delegate: PostTripToViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        TextField.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        if let text = TextField.text, !text.isEmpty{
            LocationManager.shared.findLocations(with: text, mapView: MapView){ [weak self] locations in
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
        print(String(locations.count))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Notify map controller to show pin at selected place
        
        coordinate = locations[indexPath.row].coordinates
        
        locname = locations[indexPath.row].title
        
        print(coordinate)
                
        panel.move(to: .tip, animated: true)
        
        MapView.removeAnnotations(MapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        MapView.addAnnotation(pin)
        MapView.setRegion(MKCoordinateRegion(center: coordinate,
                                             span: MKCoordinateSpan(
                                                latitudeDelta: 0.7,
                                                longitudeDelta: 0.7
                                             )
        ),
        animated: true)
        }

    
    @IBAction func ContinueButtonTapped(_ sender: Any) {
        delegate?.postTripToViewControlle(self, didSelectLocationWith: coordinate, btitle: locname)
        if changingLoc == false
        {
            ptToLatitude = coordinate.latitude
            ptToLongitude = coordinate.longitude
            let PostTripViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripVC") as! PostTripViewController
            present(PostTripViewController, animated: true, completion: nil)
            
        }
        else
        {
            toLoc = locname
            let PostFinalViewController = storyboard?.instantiateViewController(withIdentifier: "PostFinalVC") as! PostFinalViewController
            present(PostFinalViewController, animated: true, completion: nil)
        }
    }
}

