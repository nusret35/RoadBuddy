//
//  InboxViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 28.01.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
import CoreMedia

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noMessagesLabel:UILabel = {
        let label = UILabel()
        label.text = "No Messages"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.font = .systemFont(ofSize:21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.addSubview(tableView)
        view.addSubview(noMessagesLabel)
        setUpTableView()
        fetchConversations()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView()
    {
        tableView.isHidden = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations()
    {
        tableView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Other User"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
