//
//  PostTripViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 3.10.2021.
//

import UIKit
import CoreLocation

var fromLoc = ""

var toLoc = ""

var timeString = ""

var changingLoc = false

var changingTime = false

protocol PostTripViewControllerDelegate: AnyObject {
    func postTripViewController(_ vc: PostTripViewController)
}

class PostTripViewController: UIViewController {

    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var FromButton: UIButton!
    
    @IBOutlet weak var ToButton: UIButton!

    @IBOutlet weak var TimeButton: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var timeButtonTitle:String! = "Choose date and time..."
    
    var buttonTitle:String! = "Choose a location..."
    
    weak var delegate: PostTripViewControllerDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        TimeButton.setTitle(timeButtonTitle, for: .normal)
        FromButton.setTitle(buttonTitle, for: .normal)
        ToButton.setTitle(buttonTitle, for: .normal)
        errorLabel.alpha = 0
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
        DateTimeViewController.delegate = self  //PostTripViewController declaring itself to be the delegate
        present(DateTimeViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func FromButtonAction(_ sender: Any) {
        let PostTripFromViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripFromVC") as! PostTripFromViewController
        PostTripFromViewController.delegate = self
        present(PostTripFromViewController, animated: true, completion: nil)
    }
    
    @IBAction func ToButtonAction(_ sender: Any) {
        let PostTripToViewController = storyboard?.instantiateViewController(withIdentifier: "PostTripToVC") as! PostTripToViewController
        PostTripToViewController.delegate = self
        present(PostTripToViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        let error = validateFields()
        if error != nil
        {
            showError(message: error!)
        }
        else
            {
                
                let passengerPriceViewController = storyboard?.instantiateViewController(withIdentifier: "PassengerPriceVC") as! PassengerPriceViewController
                present(passengerPriceViewController, animated: true, completion: nil)
            }
        }
    
    
    @IBAction func BackButtonAction(_ sender: Any)
    {
       dismiss(animated: true, completion: nil)
    }
    
    }



extension PostTripViewController: DateTimeViewControllerDelegate {
    func dateTimeViewController(_ vc: DateTimeViewController, time: String) {
        timeString = time
        TimeButton.setTitle(time, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

extension PostTripViewController: PostTripFromViewControllerDelegate {
    func postTripFromViewController(_ vc: PostTripFromViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String) {
        fromLoc = btitle
        FromButton.setTitle(btitle, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}

extension PostTripViewController: PostTripToViewControllerDelegate {
    func postTripToViewControlle(_ vc: PostTripToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String) {
        toLoc = btitle
        ToButton.setTitle(btitle, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
