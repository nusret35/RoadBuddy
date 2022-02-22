//
//  InboxViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 28.01.2022.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import JGProgressHUD
import CoreMedia

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageTableViewCellDelegate {
    
    private var models = [InboxObject]()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView : UITableView =
    {
        let table = UITableView()
        table.isHidden = true
        table.register(MessageTableViewCell.nib(), forCellReuseIdentifier: MessageTableViewCell.identifier)
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
        getInboxData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTableView()
    {
        tableView.isHidden = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchConversations()
    {
        tableView.isHidden = false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as! MessageTableViewCell
        cell.configure(with: self.models[indexPath.row])
        cell.cellDelegate = self
        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if models[indexPath.row].requestPending == false && models[indexPath.row].requestAccepted == true
        {
            tableView.deselectRow(at: indexPath, animated: true)
            let vc = ChatViewController()
            vc.title = models[indexPath.row].username
            vc.otherUserUID = models[indexPath.row].uid
            vc.otherUserUsername = models[indexPath.row].username
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    func getInboxData()
    {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).observeSingleEvent(of: .value) { [self] snapshot in
            for child in snapshot.children
            {
                let snap = child as! DataSnapshot
                guard let res = snap.value as? [String:Any]
                else {return}
                let username = res["username"] as! String
                print(username)
               // let message = res["message"] as! String
               // let profilePictureURL = res["profilePictureURL"] as! String
                let uid = res["uid"] as! String
                let requestPending = res["requestPending"] as! Bool
                let requestAccepted = res["requestAccepted"] as! Bool
                if (requestPending == true && requestAccepted == false) || (requestPending == false && requestAccepted == true)
                {
                   let data = InboxObject(username: username, profilePictureURL: "", message: "Wants to join your trip", uid: uid, requestPending:  requestPending,requestAccepted:requestAccepted)

                    models.append(data)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func didPressAccept(_ tag: Int) {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child(self.models[tag].uid).updateChildValues(["requestAccepted":true, "requestPending":false])
        models[tag].requestPending = false
        models[tag].requestAccepted = true
        tableView.reloadData()
        print("accept button pushed")
    }
    
    func didPressReject(_ tag: Int) {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child(self.models[tag].uid).updateChildValues(["requestAccepted":false, "requestPending":false])
        //models[tag].requestPending = false
        //models[tag].requestAccepted = false
        models.remove(at: tag)
        tableView.reloadData()
        print("reject button pushed")
    }

}
