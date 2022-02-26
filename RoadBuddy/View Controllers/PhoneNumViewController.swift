//
//  PhoneNumViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class PhoneNumViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: PhoneRegionCodeViewController2())

    
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBOutlet weak var errorLable: UILabel!
    
    @IBOutlet weak var toNamesButton: UIButton!
    @IBOutlet weak var leftview: UIView!
    
    @IBOutlet weak var regionButton: UIButton!
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLable.alpha = 0
        self.hideKeyboardWhenTappedAround()
        regionButton.setTitle("+90", for: .normal)
        phoneNumTextField.leftView = leftview
        phoneNumTextField.leftViewMode = . always
    
       

        
    }
    
    @IBAction func phoneNumAction(_ sender: Any)
    {
        errorLable.text = ""
    }
    
    @IBAction func phoneNumCleanAction(_ sender: Any)
    {
        if errorLable.text != ""
        {
            phoneNumTextField.text = ""
        }
    }
    
    
    
    override func viewDidLayoutSubviews()
    {
    }
    func validateFields() -> String?
    {
        
    
        
        //Check that all fields are filled in
        if phoneNumTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            
            return "Please enter a valid phone number".localized()
        }
        else if phoneNumTextField.text!.count > 11
        {
            return "Please make sure the phone number is in the range.".localized()
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
            
            viewController.title = "Personal Info".localized()
            
            navigationController?.pushViewController(viewController, animated: true)
        }
            
        
    }
    
    @IBAction func regionButtonAction(_ sender: Any)
    {
        let vc =  storyboard?.instantiateViewController(withIdentifier: "RegionCodeVC") as! PhoneRegionCodeViewController2
        vc.delegate = self
        present(vc, animated: true, completion : nil)

    }
    
    
    func showError (message:String)
    {
        
        errorLable.text = message
        errorLable.alpha = 1
    }


}
extension PhoneNumViewController: PhoneRegionCodeDelegate
{
    func didTapRegion(regionCode: String) {
        regionButton.setTitle(regionCode, for: .normal)
    }
}
