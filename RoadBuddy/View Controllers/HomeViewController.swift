//
//  HomeViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-24.
//

import UIKit

struct Request
{
    var from:String
    var to:String
    var passengerNumber:Int
    var date:String
    var status:String
    var type:String
}

protocol HomeViewControllerDelegate: AnyObject
{
    func didTapMenuButton()
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: HomeViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    let defaultRequest = Request(from: "Istanbul", to: "Ankara", passengerNumber: 2, date: "Monday, Feb 28 2022 (15:00)", status: "Accepted", type: "Trip Request")
    
    let defaultRequest2 = Request(from: "Istanbul", to: "Ankara", passengerNumber: 2, date: "Tuesday, March 1 2022 (16:00)", status: "Rejected", type: "Taxi Share")
    
    let defaultRequest3 = Request(from: "Istanbul", to: "Izmir", passengerNumber: 2, date: "Tuesday, March 1 2022 (17:00)", status: "Pending", type: "Trip Post")
    
    var models = [[Request]]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        CurrentUser.fetchData()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        let model1 = [defaultRequest]
        let model2 = [defaultRequest2, defaultRequest3]
        models = [model1,model2]
        setUpTableView()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))
    }
    
    @objc func didTapMenuButton()
    {
        delegate?.didTapMenuButton()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func setUpTableView()
    {
        tableView.register(MyTripTableViewCell.nib(), forCellReuseIdentifier: MyTripTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        tableView.contentInset = insets
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
        cell.configure(with: self.models[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*
        let previousSection = section - 1
        if previousSection != -1
        {
            if myDateFormat.takeDayFromStringDate(models[previousSection].date) == myDateFormat.takeDayFromStringDate(models[previousSection].date)
            {
                print("dates are same")
                return ""
            }
        }
        */
        return myDateFormat.takeDayFromStringDate(models[section][0].date)
    }
    
    func scrollToTop()
    {
        let topOffest = CGPoint(x: 0, y: -(tableView.contentInset.top + 20))
        tableView.setContentOffset(topOffest, animated: false)
    }
    



}
