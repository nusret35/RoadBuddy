//
//  SetBirthdayViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-17.
//

import UIKit

class SetBirthdayViewController: UIViewController {

    
    @IBOutlet weak var SetBirthDateField: UIDatePicker!
    
    @IBOutlet weak var toPhoneNumButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let year = DateComponents(year:-18)
        SetBirthDateField.maximumDate = Calendar.current.date(byAdding: year, to: Date())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toPhoneNumButton.isUserInteractionEnabled = true
    }
    
    @IBAction func toPhoneNumAction(_ sender: Any)
    {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "PhoneNumVC") as! PhoneNumViewController
        
        viewController.title = "Add Phone Number".localized()
        
        navigationController?.pushViewController(viewController, animated: true)
        toPhoneNumButton.isUserInteractionEnabled = false
    }
    
    @IBAction func SetBirthdateAction(_ sender: UIDatePicker)
    {
        settingType(sender.date)
    }
    
    func settingType(_ date:Date)
    {
        let stringDate = myDateFormat.dateToString(date)
        
        NewUser.birthdate = stringDate

        
    }
    


}
