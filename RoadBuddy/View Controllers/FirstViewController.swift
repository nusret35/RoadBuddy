//
//  FirstViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 8.02.2022.
//

import UIKit
import FirebaseAuth


var CurrentUser = CurrentUserData()

var storageManager = StorageManager()

var firstAppearance = true

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    private let tableView = UITableView()
    
    let registrationStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    
    
    @IBAction func profileButtonAction(_ sender: Any)
    {
        let profilePageViewController = storyboard?.instantiateViewController(withIdentifier:"ProfilePageVC") as! ProfilePageViewController
        present(profilePageViewController,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        CurrentUser.fetchData()
        view.addSubview(tableView)
        navigationItem.backBarButtonItem = Buttons.defaultBackButtonWithoutTitle
        tableView.register(FirstTableViewCell.nib(),forCellReuseIdentifier: FirstTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if firstAppearance
        {
            let animation = AnimationType.from(direction: .bottom, offset: 300)
            UIView.animate(views: tableView.visibleCells, animations: [animation], delay: 0.5, duration: 1)
            firstAppearance = false
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    func authenticateUser()
    {
        if Auth.auth().currentUser == nil
        {
        DispatchQueue.main.async
            {
                
                let homePageNavigationController = self.registrationStoryboard.instantiateViewController(withIdentifier: "HomePageNC") as! UINavigationController
                self.present(homePageNavigationController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier, for: indexPath) as! FirstTableViewCell
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0
        {
            cell.backgroundColor = UIColor.yellow
            //cell.accessoryView.tintColor = UIColor.yellow
        }
        if indexPath.row == 1
        {
            cell.backgroundColor = UIColor.red
           // cell.accessoryView.tintColor = UIColor.red
        }
        if indexPath.row == 2
        {
            cell.backgroundColor = UIColor.blue
            //cell.accessoryView.tintColor = UIColor.blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0
        {
            let searchFromViewController = SearchFromViewController()
            navigationController?.pushViewController(searchFromViewController, animated: true)
            
        }
        if indexPath.row == 1
        {
            let postViewController = PostTripFromViewController2()
            navigationController?.pushViewController(postViewController, animated: true)
        }
        
        if indexPath.row == 2
        {
            let shareTaxiViewController = ShareTaxiFromViewController2()
            navigationController?.pushViewController(shareTaxiViewController, animated: true)
        }
    }
    

}
