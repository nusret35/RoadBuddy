//
//  NamesViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class NamesViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    @IBOutlet weak var completeSignUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        
    }
    
    func validateFields() -> String? {
        
        //Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please fill in all fields.".localized()
        }
        return nil
    }
    
    @IBAction func completeSignUpAction(_ sender: Any)
    {
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
