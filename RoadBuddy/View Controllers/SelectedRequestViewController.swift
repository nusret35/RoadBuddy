//
//  SelectedRequestViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 1.01.2021.
//

import UIKit

class SelectedRequestViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fromLocationLabel: UILabel!
    
    @IBOutlet weak var toLocationLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var passengerButton: UIButton!
    
    @IBOutlet weak var pricePassengerStackView: UIStackView!
    
    
    private let type:String
    
    private let fromLocationText:String
    
    private let toLocationText:String
    
    private let dateText:String
    
    private let price:String
    
    private let passengerNumber:String
    
    private let status:String
    
    private let tripID:String
    
    init(fromLocation:String,toLocation:String,date:String,type:String,price:String,passengerNumber:String,status:String,tripID:String)
    {
        self.fromLocationText = fromLocation
        self.toLocationText = toLocation
        self.dateText = date
        self.type = type
        self.price = price
        self.passengerNumber = passengerNumber
        self.status = status
        self.tripID = tripID
        super.init(nibName: "SelectedRequestViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        fromLocationLabel.text = fromLocationText
        toLocationLabel.text = toLocationText
        dateLabel.text = dateText
        if type == "Trip Request"
        {
            deleteButton.setTitle("Delete Trip Request", for: .normal)
            if status == "Accepted"
            {
                setPriceAndPassengerNumberOnView()
            }
            else
            {
                pricePassengerStackView.isHidden = true
            }
        }
        else if type == "Taxi Request"
        {
            deleteButton.setTitle("Delete Taxi Request", for: .normal)
            //later add status features
            pricePassengerStackView.isHidden = true
            
        }
        else if type == "Trip Post"
        {
            deleteButton.setTitle("Delete Trip Post", for: .normal)
            setPriceAndPassengerNumberOnView()
        }
    }
    
    func setPriceAndPassengerNumberOnView()
    {
        priceLabel.text = price + "₺"
        passengerButton.setTitle(passengerNumber, for: .normal)
    }
    
    @IBAction func deleteButtonAction(_ sender: Any)
    {
        if type == "Trip Request"
        {
            
        }
        else if type == "Trip Post"
        {
            
        }
        else if type == "Taxi Request"
        {
            
        }
    }
    

}
