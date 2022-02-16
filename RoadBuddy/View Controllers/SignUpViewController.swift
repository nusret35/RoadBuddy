//
//  SignUpViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 12.12.2021.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var BackButton: UIButton!
    
    @IBOutlet weak var FirstNameTextField: UITextField!
    
    @IBOutlet weak var LastNameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var UsernameTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var SchoolNameTextField: UITextField!
    
    @IBOutlet weak var PhoneNumberTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()


    }
    
    func setUpElements(){
        
        //Hide the error label
        errorLabel.alpha = 0
    
        //Style the elements
       
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
        
        FirstNameTextField.inputAccessoryView = toolBar
        LastNameTextField.inputAccessoryView = toolBar
        EmailTextField.inputAccessoryView = toolBar
        UsernameTextField.inputAccessoryView = toolBar
        PasswordTextField.inputAccessoryView = toolBar
        
        toolBar.setItems([doneButton], animated: false)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if FirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || LastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || UsernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PhoneNumberTextField.text?.trimmingCharacters(in:.whitespacesAndNewlines) == "" ||
            SchoolNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters contains a special character and a number.".localized()
        }
        
        return nil
    }
    
    @IBAction func backButtonAction(_ sender: Any)
    {
        dismiss(animated: true)
    }
    
    @IBAction func SignUpTapped(_ sender: Any)
    {
        // Validate the fields
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show the error message
            showError(message: error!)
        }else{
        
        // Create cleaned versions of data
            let firstName = FirstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let lastName = LastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let userName = UsernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            
            let password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let phoneNumber = PhoneNumberTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let schoolName = SchoolNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                //Check for errors
                if err != nil {
                    // There was an error creating the user
                    showError(message: "Error creating user")
                }
                else{
                    
                    // User was created successfully, now store the first name and last name of the user
                    
                    let db = Firestore.firestore()
                    let uid = result!.user.uid
                    db.collection("users").document(String(uid)).setData( ["firstname":firstName,"lastname":lastName,"username":userName,"uid":result!.user.uid,"email":email,"password":password,"phoneNumber":phoneNumber,"schoolName":schoolName, "TripIsSet":false,"TaxiTripIsSet":false,"profilePictureIsSet":false
                        ,"lookingForATrip":false]) { (error) in
                        
                        if error != nil {
                            //Show error message
                            showError(message: "Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    transitionToHome()
                }
            }

            
        }
        
    
    func showError (message:String)
        {
        
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
}

extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
