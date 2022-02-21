//
//  NamesViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

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


    @IBAction func completeSignUpAction(_ sender: Any)
    {
        let error = validateNames()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
           
        }
    }
    let allowedCharacters = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        
        if string == filtered {
            
            return true

        } else {
            
            return false
        }
    }
    
    func validateNames() -> String?
    {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in all fields.".localized()
        }
        else if textField(firstNameTextField, shouldChangeCharactersIn: NSMakeRange(1, 75), replacementString: "hdh") == false
        {
            return "Please make sure Firstname does not contain any numbers or special characters"
        }
        else if textField(lastNameTextField, shouldChangeCharactersIn: NSMakeRange(1, 75), replacementString: "") == false
        {
            return "Please make sure Lastname does not contain any numbers or special characters"
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

