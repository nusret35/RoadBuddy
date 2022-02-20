//
//  PhoneNumViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class PhoneNumViewController: UIViewController {

    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    
    @IBOutlet weak var toNamesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
    }
    
   
    @IBAction func toNamesAction(_ sender: Any)
    {
        NewUser.phoneNum = phoneNumTextField.text!
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "NamesVC") as! NamesViewController
        
        viewController.title = "Personal Info"
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    


}
