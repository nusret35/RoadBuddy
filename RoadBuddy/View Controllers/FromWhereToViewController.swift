//
//  FromWhereToViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 24.09.2021.
//

import UIKit
import CoreLocation
import FirebaseAuth
import MapKit

var SearchFrom = "From..."

var SearchTo = "To..."


class FromWhereToViewController: UIViewController{

    let mapsStoryboard = UIStoryboard(name: "Maps", bundle: nil)
    
    let registrationStoryboard = UIStoryboard(name:"Registration",bundle:nil)
    
    @IBOutlet weak var WhereToButton: UIButton! //From button
    
    @IBOutlet weak var WhereToLabel: UILabel!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        errorLabel.alpha = 0
        WhereToButton.setTitle(SearchFrom, for: .normal)
        ToButton.setTitle(SearchTo, for: .normal)
    }
    //FUNCTIONS
    
    func validateFields() ->String? {
        if WhereToButton.titleLabel!.text! == "From..." || ToButton.titleLabel!.text! == "To..."
        {
            return "Please choose a location"
        }
        return nil
    }
    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    

    
    //BUTTON ACTIONS
    
    @IBAction func ButtonAction(_ sender: Any) {  //From button action
        let viewcontroller = mapsStoryboard.instantiateViewController(withIdentifier: "VCNC") as! UINavigationController
        present(viewcontroller, animated: true, completion: nil)
    }
    
    
    @IBAction func ToButtonAction(_ sender: Any) {
        let ToViewController = mapsStoryboard.instantiateViewController(withIdentifier: "ToNC") as! UINavigationController
        present(ToViewController, animated: true, completion: nil)
    }
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        let error = validateFields()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            let request = SearchTripRequest(fullname: currentUser.Fullname, uid: currentUser.UID, fromLocationName: SearchFrom, toLocationName: SearchTo, fromCoordinateLat: SearchFromLocation.coordinate.latitude, fromCoordinateLong: SearchFromLocation.coordinate.longitude, toCoordinateLat: SearchToLocation.coordinate.latitude, toCoordinateLong: SearchToLocation.coordinate.longitude)
            
        }
    }
    
    
}



