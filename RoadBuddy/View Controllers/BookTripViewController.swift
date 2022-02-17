//
//  BookTripViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 25.01.2022.
//
/*
import UIKit
import FirebaseDatabase

class BookTripViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var textBox: UITextField!
    
    @IBOutlet weak var bookTheTripButton: UIButton!
    
    @IBOutlet weak var dropDown: UIPickerView!
    
    
    let ref = Database.database().reference()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        SetUpElement()
        textBox.delegate = self
        dropDown.delegate = self
        dropDown.tintColor = .white
    }
    
    @IBAction func bookTheTripButtonAction(_ sender: Any)
    {
        
    }
    
    func SetUpElement()
    {
    }
    
    //pickerview functions

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return SeatsAvaliable
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return SeatsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString?
    {
        return NSAttributedString(string: SeatsList[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.textBox.text = SeatsList[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        if textField == self.textBox {
            self.dropDown.isHidden = false
            textField.endEditing(true)
        }

    }
    
    
    
}
*/
