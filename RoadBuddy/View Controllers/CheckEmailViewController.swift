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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toUsernameButton.isUserInteractionEnabled = true
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
            return "Please enter a valid E-mail adress".localized()
        }
        
        return nil
    }

    
    
    @IBAction func textFieldInputAction(_ sender: Any)
    {
        errorLable.text = ""
        
        
    }
    
    @IBAction func emailCleanAction(_ sender: Any)
    {
        if errorLable.text != ""
        {
            setEmailTextField.text = ""
        }
    }
    
    
    

    
    @IBAction func toUsernameAction(_ sender: Any)
    {
        let error = validateEmail()
        
        var emailExists = false
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            storageManager.db.collection("users").getDocuments()
            {
                snapshot, error in
                if let error = error {
                    print("error finding documents")
                }
                for document in snapshot!.documents
                {
                    let data = document.data()
                    let email = data["email"] as! String
                    print(email)
                    if self.setEmailTextField.text! == email
                    {
                        emailExists = true
                    }
                }
                if emailExists == false
                {
                    NewUser.email = self.setEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "UserNameVC") as! UserNameViewController
                    viewController.title = "Create Username".localized()
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                    self.toUsernameButton.isUserInteractionEnabled = false
                }
                else
                {
                    self.showError(message: "The E-mail already been used, please log in or enter different E-mail.".localized())
                }
                
            }
        }
        
        
        
    }
    
    func showError (message:String)
    {
        
        errorLable.text = message
        errorLable.alpha = 1
    }
    

}
