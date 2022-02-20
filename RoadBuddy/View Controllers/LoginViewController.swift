//
//  LoginViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 12.12.2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!


    @IBOutlet weak var LogInButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        LogInButton.setTitle("Login".localized(), for: .normal)
        
        EmailTextField.placeholder = "Email".localized()
        
        PasswordTextField.placeholder = "Password".localized()

        // Do any additional setup after loading the view.
        setUpElements()
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        EmailTextField.inputAccessoryView = toolBar
        PasswordTextField.inputAccessoryView = toolBar
        toolBar.setItems([doneButton], animated: false)
        
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }

    func setUpElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
        
        //Style the elements
        
    }
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields.".localized()
        }
        return nil
    }


    @IBAction func LogInButton(_ sender: Any) {
        //Validate Text Fields
        let error = validateFields()
        
        if error != nil {
            // There's something wrong with the fields, show the error message
            showError(message: error!)
        }else{
        
        // Create cleaned version
        let email = EmailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
        let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            spinner.show(in: view)
            
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            DispatchQueue.main.async
            {
                self.spinner.dismiss()
            }
            if error != nil
            {
                //Couldn't sign in
                self.showError(message: "Log in unsuccessful. Check your email or password.".localized())
                
            }
            else
            {
                self.transitionToHome()
            }
        }
        }
    }
    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    
func transitionToHome ()
    {
        let mainStoryboard = UIStoryboard(name:"Main",bundle:nil)
        let firstNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "FirstNC") as! UINavigationController
        present(firstNavigationController, animated: true, completion: nil)
    }
    
}
