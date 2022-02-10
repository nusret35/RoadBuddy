//
//  PostTripViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 3.10.2021.
//

import UIKit
import CoreLocation

var FromLoc = "Choose a location..."

var ToLoc = "Choose a location..."

var TimeString = "Choose date and time..."

class PostTripViewController: UIViewController {
    
   

    
    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!

    @IBOutlet weak var TimeButton: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let mapsStoryboard = UIStoryboard(name:"Maps",bundle:nil)
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated:Bool)
    {
        super.viewDidAppear(true)
        TimeButton.setTitle(TimeString, for: .normal)
        FromButton.setTitle(FromLoc, for: .normal)
        ToButton.setTitle(ToLoc, for: .normal)
    }
    
    //FUNCTIONS
    
    func validateFields() ->String? {
        if FromButton.titleLabel!.text! == "Choose a location..." || ToButton.titleLabel!.text! == "Choose a location..."
        {
            return "Please choose a location"
        }
        else if TimeButton.titleLabel!.text! == "Choose date and time..."
        {
            return "Please choose a time frame"
        }
        return nil
    }

    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    
    //BUTTON ACTIONS
    
    @IBAction func TimeButtonAction(_ sender: Any) {
        let DateTimeViewController = storyboard?.instantiateViewController(withIdentifier: "DateTimeVC") as! DateTimeViewController
        present(DateTimeViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func FromButtonAction(_ sender: Any) {

        let PostTripFromViewController = mapsStoryboard.instantiateViewController(withIdentifier:  "PostTripFromVC") as! PostTripFromViewController
 
        navigationController?.pushViewController(PostTripFromViewController, animated: true)
    }
    
    @IBAction func ToButtonAction(_ sender: Any) {        
        let PostTripToViewController = mapsStoryboard.instantiateViewController(withIdentifier:  "PostTripToVC") as! PostTripToViewController
 
        navigationController?.pushViewController(PostTripToViewController, animated: true)
    }
    
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        let error = validateFields()
        if error != nil
        {
            showError(message: error!)
        }
        else
            {
                let vc = storyboard?.instantiateViewController(withIdentifier: "PassengerPriceVC") as! PassengerPriceViewController
                vc.title = "How many passengers?"
                vc.navigationItem.largeTitleDisplayMode = .always
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    
    
    }

