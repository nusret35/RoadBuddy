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
    var price:Int
    var passengerNumber:Int
    var date:String
    var status:String
    var type:String
    var tripID:String
}

protocol HomeViewControllerDelegate: AnyObject
{
    func didTapMenuButton()
}
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: HomeViewControllerDelegate?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var label: UILabel!
    
    
    var models = [[Request]]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        logInCheck()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))

        setUpElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidLoad()
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
        label.isHidden = true
        let group = DispatchGroup()
        //let queue = DispatchQueue(label: "someQueue")
        group.enter()
        CurrentUser.homeFetchData(myGroup: group)
        group.notify(queue: .main, execute:
        {
            print("data has fetched")
            storageManager.retrieveAllRequestsOfUser { [self] requests in
                if requests.isEmpty == true
                {
                    tableView.isHidden = true
                    label.isHidden = false
                }
                else
                {
                    tableView.isHidden = false
                    models = requests
                    setUpTableView()
                }
            }
        })
        
    }
    
    func setUpTableView()
    {
        tableView.register(MyTripTableViewCell.nib(), forCellReuseIdentifier: MyTripTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
                tableView.reloadData()
                if requests.isEmpty == true
                {
                    tableView.isHidden = true
                    label.isHidden = false
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTripTableViewCell.identifier, for: indexPath) as! MyTripTableViewCell
        cell.configure(with: self.models[indexPath.section][indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = models[indexPath.section][indexPath.row]
        let vc = SelectedRequestViewController(fromLocation: selectedCell.from, toLocation: selectedCell.to, date: selectedCell.date, type: selectedCell.type, price: String(selectedCell.price), passengerNumber: String(selectedCell.passengerNumber), status: selectedCell.status, tripID: selectedCell.tripID)
        present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 250
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        print(String(models[section].count))
        return myDateFormat.takeDayFromStringDate(models[section][0].date)
    }
     
    
    func scrollToTop()
    {
        let topOffest = CGPoint(x: 0, y: -(tableView.contentInset.top + 20))
        tableView.setContentOffset(topOffest, animated: false)
    }

    func logInCheck()
    {
        if storageManager.checkIfUserLoggedIn() == false
        {
            let storyboard = UIStoryboard(name: "Registration", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomePageNC") as! UINavigationController
            present(vc,animated: true)
        }
    }


}
