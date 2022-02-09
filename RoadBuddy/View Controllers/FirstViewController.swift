//
//  FirstViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 8.02.2022.
//

import UIKit
import FirebaseAuth


var currentUser = CurrentUserData()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    private let tableView = UITableView()
    
    let registrationStoryboard = UIStoryboard(name: "Registration", bundle: nil)
    
    
    @IBAction func profileButtonAction(_ sender: Any)
    {
        let profilePageViewController = storyboard?.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageViewController
        present(profilePageViewController,animated: true,completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        currentUser.fetchData()
        view.addSubview(tableView)
        tableView.backgroundColor = BackgroundColor.defaultBackgroundColor
        tableView.register(FirstTableViewCell.nib(),forCellReuseIdentifier: FirstTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let animation = AnimationType.from(direction: .bottom, offset: 300)
        UIView.animate(views: tableView.visibleCells, animations: [animation], delay: 0.5, duration: 1)
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
        if indexPath.row == 0
        {
            cell.view.backgroundColor = UIColor.yellow
        }
        if indexPath.row == 1
        {
            cell.view.backgroundColor = UIColor.red
        }
        if indexPath.row == 2
        {
            cell.view.backgroundColor = UIColor.blue
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
        if indexPath.row == 0
        {
            let fromWhereNavigationController = storyboard?.instantiateViewController(withIdentifier: "FromWhereNC") as! UINavigationController
            present(fromWhereNavigationController, animated: true, completion: nil)
        }
        if indexPath.row == 1
        {
            let postNavigationController = storyboard?.instantiateViewController(withIdentifier: "PostNC") as! UINavigationController
            present(postNavigationController, animated: true, completion: nil)
        }
        
        if indexPath.row == 2
        {
            let shareTaxiNavigationController = storyboard?.instantiateViewController(withIdentifier: "ShareTaxiNC") as! UINavigationController
            present(shareTaxiNavigationController, animated: true, completion: nil)
        }
    }
    

}
