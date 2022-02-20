//
//  CheckEmailViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class CheckEmailViewController: UIViewController {

    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var toUsernameButton: UIButton!
    @IBOutlet weak var setEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLable.alpha = 0
        self.hideKeyboardWhenTappedAround()

        
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func validateEmail() -> String?
    {
        let cleanEmail = setEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isValidEmailAddress(emailAddressString: cleanEmail) == false
        {
            return "Please enter a valid E-mail adress"
        }
        
        return nil
    }

    

    
    @IBAction func toUsernameAction(_ sender: Any)
    {
        let error = validateEmail()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            NewUser.email = setEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "UserNameVC") as! UserNameViewController
            viewController.title = "Create Username"
            
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        
    }
    
    func showError (message:String)
    {
        
        errorLable.text = message
        errorLable.alpha = 1
    }
    

}
