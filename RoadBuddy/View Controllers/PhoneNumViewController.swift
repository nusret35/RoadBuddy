//
//  PhoneNumViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class PhoneNumViewController: UIViewController {

    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var toNamesButton: UIButton!
    @IBOutlet weak var leftview: UIView!
    
    @IBOutlet weak var regionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        phoneNumTextField.leftView = leftview
        phoneNumTextField.leftViewMode = . always
    
       

        
    }
    
    override func viewDidLayoutSubviews()
    {
    }
    func validateFields() -> String?
    {
        
    
        
        //Check that all fields are filled in
        if phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please enter the phone number".localized()
        }
        else if phoneNumTextField.text!.count > 11
        {
            return "Please make sure the phone number is in the range."
        }
        return nil
    }
   
    @IBAction func toNamesAction(_ sender: Any)
    {
        let error = validateFields()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            NewUser.phoneNum = phoneNumTextField.text!
            
            let viewController = storyboard?.instantiateViewController(withIdentifier: "NamesVC") as! NamesViewController
            
            viewController.title = "Personal Info"
            
            navigationController?.pushViewController(viewController, animated: true)
        }
            
        
    }
    
    @IBAction func regionButtonAction(_ sender: Any)
    {
        let vc = PhoneRegionCodeViewController()
        present(vc, animated: true, completion: nil)
    }
    
    
    func showError (message:String)
    {
        
        errorLable.text = message
        errorLable.alpha = 1
    }


    
    


}
