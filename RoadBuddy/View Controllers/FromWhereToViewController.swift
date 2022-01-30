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

var SearchFrom = ""

var SearchTo = ""


class FromWhereToViewController: UIViewController{

    //From button
    @IBOutlet weak var WhereToButton: UIButton!
    
    @IBOutlet weak var WhereToLabel: UILabel!
    
    @IBOutlet weak var ToButton: UIButton!
    
    @IBOutlet weak var ContinueButton: UIButton!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    
    var buttontitle: String! = "Choose a location..."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        errorLabel.alpha = 0
        WhereToButton.setTitle(buttontitle, for: .normal)
        WhereToButton.setTitleColor(.white, for: .normal)
        ToButton.setTitle(buttontitle, for: .normal)
        ToButton.setTitleColor(.white, for: .normal)
    }
    
    //FUNCTIONS
    
    func validateFields() ->String? {
        if WhereToButton.titleLabel!.text! == "Choose a location..." || ToButton.titleLabel!.text! == "Choose a location"
        {
            return "Please choose a location"
        }
        return nil
    }
    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    
    //API
    func authenticateUser()
    {
        if Auth.auth().currentUser == nil
        {
        DispatchQueue.main.async
            {
                
                let homePageViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomePageVC") as! HomePageViewController
                self.present(homePageViewController, animated: true, completion: nil)
            }
        }
    }
    
    //BUTTON ACTIONS
    
    @IBAction func ButtonAction(_ sender: Any) {  //From button action
        let viewcontroller = storyboard?.instantiateViewController(withIdentifier: "VC") as! VC
        viewcontroller.delegate = self
        present(viewcontroller, animated: true, completion: nil)
    }
    
    
    @IBAction func ToButtonAction(_ sender: Any) {
        let ToViewController = storyboard?.instantiateViewController(withIdentifier: "ToVC") as! ToViewController
        ToViewController.delegate = self
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
            let ResultsViewController = storyboard?.instantiateViewController(withIdentifier: "ResultsNC") as! ResultsNavigationController
            present(ResultsViewController, animated: true, completion: nil)
        }
    }
    
    
}

extension FromWhereToViewController: VCDelegate {
    func vcfunction(_ vc: VC, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle:String){
        WhereToButton.setTitle(btitle, for: .normal)
        SearchFrom = btitle
        dismiss(animated: true, completion: nil)
    }
}

extension  FromWhereToViewController: ToViewControllerDelegate {
    func toViewController(_ viewcontroller: ToViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D, btitle: String) {
        ToButton.setTitle(btitle, for: .normal)
        SearchTo = btitle
        dismiss(animated: true, completion: nil)
    }
}



