//
//  UserNameViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-16.
//

import UIKit


class UserNameViewController: UIViewController {

    @IBOutlet weak var userNameTexiField: UITextField!
    
    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var toPasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLable.alpha = 0
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toPasswordButton.isUserInteractionEnabled = true
    }
    
    @IBAction func userNameInputAction(_ sender: Any)
    {
        errorLable.text = ""
        
    }
    @IBAction func usernameInputDidBegin(_ sender: Any)
    {
        if errorLable.text != ""
        {
            userNameTexiField.text = ""
        }
    }
    
    func validateUsername() -> String?
    {

        if userNameTexiField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please enter a valid username".localized()
        }
        return nil
    }
    
    
    @IBAction func toPasswordAction(_ sender: Any)
    {
        let error = validateUsername()
        
        var usernameExists = false
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            storageManager.db.collection("users").getDocuments()
            {
                snapshot, error in
                if let error = error
                {
                    print("error finding documents")
                }
                
                for document in snapshot!.documents
                {
                    let data = document.data()
                    let username = data["username"] as! String
                    print(username)
                    if self.userNameTexiField.text! == username
                    {
                        usernameExists = true
                    }
                }
                if usernameExists == false
                {
                    NewUser.userName = self.userNameTexiField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SetPasswordVC") as! CreatePasswordViewController
                    viewController.title = "Create a password".localized()
                    
                    self.navigationController?.pushViewController(viewController, animated: true)
                    self.toPasswordButton.isUserInteractionEnabled = false
                }
                else
                {
                    self.showError(message: "The Username already been used, please enter a different username".localized())
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

    
    

    
    
    

    


