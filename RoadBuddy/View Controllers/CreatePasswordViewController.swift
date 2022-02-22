//
//  CreatePasswordViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-16.
//
//
//  CreatePasswordViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-16.
//

import UIKit

class CreatePasswordViewController: UIViewController {

    @IBOutlet weak var userPasswordTexiField: UITextField!
    @IBOutlet weak var toBirthDateButton: UIButton!
    
    @IBOutlet weak var errorlable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorlable.alpha = 0
        self.hideKeyboardWhenTappedAround()


    }
    
    @IBAction func passwordTextFieldInputAction(_ sender: Any)
    {
            errorlable.text = ""
            
    }
    
    @IBAction func passwordCleanAction(_ sender: Any)
    {
        if errorlable.text != ""
        {
            userPasswordTexiField.text = ""
        }
    }
    
    
    
    func validatePassword() -> String?
    {
                
        // Check if the password is secure
        let cleanedPassword = userPasswordTexiField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters contains a special character and a number.".localized()
        }
        
        return nil
    }
    
    
    
    @IBAction func toBirthDateAction(_ sender: Any)
    {
        let error = validatePassword()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            NewUser.passWord = userPasswordTexiField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "SetBirthdayVC") as! SetBirthdayViewController
            
            viewController.title = "Add Your Birthday".localized()
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        

    }
    
    func showError (message:String)
    {
        
        errorlable.text = message
        errorlable.alpha = 1
        
    }
    
    
    
    



}
