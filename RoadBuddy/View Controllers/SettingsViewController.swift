//
//  SettingsViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 28.02.2022.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView: UITableView =
    {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setUpTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingOptions.allCases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingOptions.allCases[indexPath.row].rawValue
        cell.backgroundColor = .systemBackground
        cell.tintColor = .label
        cell.imageView?.image = UIImage(named: settingOptions.allCases[indexPath.row].imageName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settingOptions.allCases[indexPath.row]
        didSelect(settingsItem: item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    enum settingOptions: String, CaseIterable
    {
        case signOut = "Sign Out"
        
        var imageName: String
        {
            switch self
            {
                case .signOut:
                    return "icon-sign-out"
            }
        }
    }
    
    func didSelect(settingsItem: SettingsViewController.settingOptions)
    {
        switch settingsItem
        {
        case .signOut:
            currentUserSignOut()
            break
        }
    }
    
    func currentUserSignOut()
    {
        createAlert(title: "Sign Out?", message: "")
    }
    
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Sign Out".localized(), style: UIAlertAction.Style.destructive, handler: { [self] (action) in
            do
            {
            try Auth.auth().signOut()
                let registrationStoryboard = UIStoryboard(name:"Registration",bundle:nil)
                let homePageViewController = registrationStoryboard.instantiateViewController(withIdentifier: "HomePageNC") as! UINavigationController
                self.present(homePageViewController, animated: true, completion: nil)
            }
            catch
            {
                print("sign out error")
            }
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated:true, completion: nil)
    }

}
