//
//  UserNameViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-16.
//

import UIKit


class UserNameViewController: UIViewController {

    @IBOutlet weak var userNameTexiField: UITextField!
    
    @IBOutlet weak var toPasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        

        
    }
    
    
    @IBAction func toPasswordAction(_ sender: Any)
    {

        NewUser.userName = userNameTexiField.text!
        let viewController = storyboard?.instantiateViewController(withIdentifier: "SetPasswordVC") as! CreatePasswordViewController
        viewController.title = "Create a password".localized()
        
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    

    
    
    

    

}

    
    

    
    
    

    


