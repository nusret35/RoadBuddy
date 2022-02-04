//
//  PassengerPriceViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 6.10.2021.
//

import UIKit

var passengerNumber = 0

var priceString = ""

protocol PassengerPriceViewControllerDelegate: AnyObject {
    func passengerPriceViewController (_ vc:PassengerPriceViewController, passengers: String, price: String)
}

class PassengerPriceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    //create list
    var list = ["1","2","3","4"]
    
    weak var delegate: PassengerPriceViewControllerDelegate?
    
    //Override function
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        dropDown.tintColor = .white
        textBox.delegate = self
        priceTextField.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))

        
        priceTextField.inputAccessoryView = toolBar
        
        toolBar.setItems([doneButton], animated: false)
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    
    //Pickerview functions
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1

    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

        return list.count

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return list[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: list[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        self.textBox.text = self.list[row]
        self.dropDown.isHidden = true

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == self.textBox {
            self.dropDown.isHidden = false
            //if you dont want the users to see the keyboard type:

            textField.endEditing(true)
        }

    }
    
    // UI functions
    func validateFields() ->String? {
        if textBox.text! == "0"
        {
            return "Select the number of passengers"
        }
        else if priceTextField.text! == ""
        {
            return "Specify the price"
        }
        return nil
    }

    
    func showError (message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
        }
    
    
    
    @IBAction func ContinueButtonAction(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil
        {
            showError(message: error!)
        }
        else
        {
            passengerNumber = Int(textBox.text!) ?? 0
            priceString = priceTextField.text!
            delegate?.passengerPriceViewController(self, passengers: textBox.text! , price: priceTextField.text!)
            let PostFinalViewController = storyboard?.instantiateViewController(withIdentifier: "PostFinalVC") as! PostFinalViewController
            PostFinalViewController.title = "Your Trip"
            PostFinalViewController.navigationItem.largeTitleDisplayMode = .always
            navigationController?.pushViewController(PostFinalViewController, animated: true)
        }
    }
    
    
    
    
}

