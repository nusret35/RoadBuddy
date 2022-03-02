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
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))

        setUpElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didTapMenuButton()
    {
        delegate?.didTapMenuButton()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func setUpElements()
    {
        setUpTableView()
        let group = DispatchGroup()
        //let queue = DispatchQueue(label: "someQueue")
        group.enter()
        CurrentUser.homeFetchData(myGroup: group)
        group.notify(queue: .main, execute:
        {
            print("data has fetched")
            storageManager.retrieveAllRequestsOfUser { requests in
                self.models = requests
                print(String(self.models[0].count))
                self.tableView.reloadData()
            }
        })
        
    }
    
    func setUpTableView()
    {
        tableView.register(MyTripTableViewCell.nib(), forCellReuseIdentifier: MyTripTableViewCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        tableView.separatorStyle = .none
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        tableView.contentInset = insets
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh()
    {
        // Re-fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            storageManager.retrieveAllRequestsOfUser { [self] requests in
                tableView.refreshControl?.endRefreshing()
                models.removeAll()
                models = requests
                print(String(models[0].count))
                tableView.reloadData()
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
        print(String(models[section].count))
        return myDateFormat.takeDayFromStringDate(models[section][0].date)
    }
     
    
    func scrollToTop()
    {
        let topOffest = CGPoint(x: 0, y: -(tableView.contentInset.top + 20))
        tableView.setContentOffset(topOffest, animated: false)
    }
    



}
