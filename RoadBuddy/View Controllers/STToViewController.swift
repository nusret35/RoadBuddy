//
//  STToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 21.11.2021.
//
import UIKit
import MapKit
import CoreLocation
import FloatingPanel

var stToLatitude:Double = 0.0

var stToLongitude:Double = 0.0

protocol STToViewControllerDelegate:AnyObject
{
    func stToViewController(_ vc:STToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String)
}

class STToViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let panel = FloatingPanelController()

    var locations = [Location]()
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    
    var locname: String! = "Choose a location..."
    
    weak var delegate: STToViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let text = textField.text, !text.isEmpty{
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
        
        coordinate = locations[indexPath.row].coordinates
        
        locname = locations[indexPath.row].title
        
        print(coordinate)
                
        panel.move(to: .tip, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        mapView.setRegion(MKCoordinateRegion(center: coordinate,
                                             span: MKCoordinateSpan(
                                                latitudeDelta: 0.7,
                                                longitudeDelta: 0.7
                                             )
        ),
        animated: true)
        }
    
    
    @IBAction func continueButtonAction(_ sender: Any)
    {
        stToLatitude = coordinate.latitude
        stToLongitude = coordinate.longitude
        delegate?.stToViewController(self, didSelectLocationWith: coordinate, btitle: locname)
            let TaxiTripSetViewController = storyboard?.instantiateViewController(withIdentifier: "TaxiTripSetVC") as! TaxiTripSetViewController
            present(TaxiTripSetViewController, animated: true, completion: nil)
    }


}
