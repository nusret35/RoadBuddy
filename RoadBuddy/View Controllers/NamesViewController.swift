//
//  NamesViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit
import FirebaseAuth

class NamesViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var completeSignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        errorLabel.alpha = 0

    }
    
    @IBAction func firstnameActionField(_ sender: Any)
    {
        if errorLabel.text != "Please make sure lastname does not contain any numbers or special characters"
        {
            errorLabel.text = ""
            
        }
        
    }
    
    @IBAction func firstnamecleanActionField(_ sender: Any)
    {
        if errorLabel.text != "Please make sure lastname does not contain any numbers or special characters" && errorLabel.text != ""
        {
            firstNameTextField.text = ""
            errorLabel.text = ""
        }
    }
    
    @IBAction func lastnameActionField(_ sender: Any)
    {
        if errorLabel.text != "Please make sure firstname does not contain any numbers or special characters"
        {
            errorLabel.text = ""
        }
    }
    
    @IBAction func lastnameCleanActionField(_ sender: Any)
    {
       if errorLabel.text != "Please make sure firstname does not contain any numbers or special characters" && errorLabel.text != ""
        {
            lastNameTextField.text = ""
            errorLabel.text = ""
        }
    }
    
    
    


    @IBAction func completeSignUpAction(_ sender: Any)
    {
        let error = validateNames()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            Auth.auth().createUser(withEmail: NewUser.email, password: NewUser.passWord) { (result, err) in
                //Check for errors
                if err != nil {
                    // There was an error creating the user
                    self.showError(message: "Error creating user")
                }
                else{
                    
                    // User was created successfully, now store the first name and last name of the user
                    
                    let uid = result!.user.uid
                    storageManager.db.collection("users").document(String(uid)).setData( ["firstname":self.firstNameTextField.text,"lastname":self.lastNameTextField.text,"username":NewUser.userName,"uid":result!.user.uid,"email":NewUser.email,"password":NewUser.passWord,"phoneNumber":NewUser.phoneNum,"schoolName":NewUser.schoolName,
                        "TripIsSet":false,"TaxiTripIsSet":false,"profilePictureIsSet":false
                        ,"lookingForATrip":false]) { (error) in
                        
                        if error != nil {
                            //Show error message
                            self.showError(message: "Error saving user data")
                        }
                    }
                    //Transition to the home screen
                    let vc = SidebarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    
    func isValid(testStr:String) -> Bool {
        guard testStr.count > 1, testStr.count < 50 else { return false }

        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: testStr)
    }
    
    func validateNames() -> String?
    {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in all fields.".localized()
        }
        else if isValid(testStr: firstNameTextField.text!) == false && isValid(testStr: lastNameTextField.text!) == false
        {
            lastNameTextField.text = ""
            firstNameTextField.text = ""
            return "Please make sure firstname and lastname does not contain any numbers or special characters".localized()
        }
        else if isValid(testStr: lastNameTextField.text!) == false
        {
            return "Please make sure lastname does not contain any numbers or special characters".localized()
        }
        else if isValid(testStr: firstNameTextField.text!) == false
        {
            return "Please make sure firstname does not contain any numbers or special characters".localized()
        }
        return nil
        
    }
    
    func showError (message:String)
    {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    

  

}
@IBDesignable extension UIButton {

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

