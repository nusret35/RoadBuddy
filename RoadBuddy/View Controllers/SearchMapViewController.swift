//Created by Nusret Ali Kızılaslan

import UIKit
import MapKit
import CoreLocation

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
