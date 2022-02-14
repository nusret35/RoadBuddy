//
//  SearchPassengerViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 13.02.2022.
//

import UIKit

class SearchPassengerViewController: UIViewController {

    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var plusButton: UIButton!
    
    
    private var numberOfPassengers = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = String(numberOfPassengers)
        minusButton.tintColor = .secondaryLabel
        minusButton.setTitle("", for: .normal)
    }
    
    
    
    @IBAction func minusButtonAction(_ sender: Any)
    {
        if (numberOfPassengers != 1)
        {
            numberOfPassengers -= 1
            numberLabel.text = String(numberOfPassengers)
            if numberOfPassengers == 1
            {
                minusButton.tintColor = .secondaryLabel
            }
            else if numberOfPassengers == 3
            {
                plusButton.tintColor = .label
            }
        }
    }
    
    
    @IBAction func plusButtonAction(_ sender: Any)
    {
        if (numberOfPassengers != 4)
        {
            numberOfPassengers += 1
            numberLabel.text = String(numberOfPassengers)
            if numberOfPassengers == 4
            {
                plusButton.tintColor = .secondaryLabel
            }
            else if numberOfPassengers == 2
            {
                minusButton.tintColor = .label
            }
        }
        
    }
    
    @IBAction func continueButtonAction(_ sender: Any)
    {
        UserSearchTripRequest.numberOfPassengers = numberOfPassengers
        let vc = SearchMatchRequestViewController()
        vc.title = "Searching for trips"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
}
