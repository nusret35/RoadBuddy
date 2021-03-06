//
//  SelectedRequestViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 1.01.2021.
//

import UIKit

class SelectedRequestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fromLocationLabel: UILabel!
    
    @IBOutlet weak var toLocationLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var passengerButton: UIButton!
    
    @IBOutlet weak var pricePassengerStackView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let type:String
    
    private let fromLocationText:String
    
    private let toLocationText:String
    
    private let dateText:String
    
    private let price:String
    
    private let passengerNumber:String
    
    private let status:String
    
    private let tripID:String
    
    private var array = [TemporaryStruct]()
    
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
        setUpElements{
            self.setUpTableView()
        }
    }
    
    
    
    func setUpElements(completion: @escaping () -> ())
    {
        fromLocationLabel.text = fromLocationText
        toLocationLabel.text = toLocationText
        dateLabel.text = dateText
        //tableView.isHidden = true
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
            
            storageManager.getPendingSearchRequestsArray(date: dateText) { [self] requests in
                for i in array
                {
                    print("tripID: " + i.tripID + " status: " + i.status)
                }
                array = requests
                completion()
            }
        }
        else if type == "Taxi Request"
        {
            deleteButton.setTitle("Delete Taxi Request", for: .normal)
            //later add status features
            pricePassengerStackView.isHidden = true
            
            storageManager.getPendingTaxiRequestsArray(tripID: tripID) { [self] requests in
                for i in array
                {
                    print("tripID: " + i.tripID + " status: " + i.status)
                }
                array = requests
                completion()
            }
        }
        else if type == "Trip Post"
        {
            deleteButton.setTitle("Delete Trip Post", for: .normal)
            setPriceAndPassengerNumberOnView()
        }
    }
    
    func setUpTableView()
    {
        tableView.register(SelectedRequestTableViewCell.self, forCellReuseIdentifier: SelectedRequestTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        if array.isEmpty == false
        {
            tableView.isHidden = false
            
        }
        else
        {
            print("no pending requests found")
        }
        tableView.reloadData()
    }
    
    func setPriceAndPassengerNumberOnView()
    {
        priceLabel.text = price + "₺"
        passengerButton.setTitle(passengerNumber, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let group = DispatchGroup()
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedRequestTableViewCell.identifier, for: indexPath) as! SelectedRequestTableViewCell
        cell.tintColor = .label
        cell.backgroundColor = .systemBackground
        cell.configure(with: array[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
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
