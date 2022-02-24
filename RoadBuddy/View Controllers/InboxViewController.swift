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
        //getInboxData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getInboxData()
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
        cell.configure(with: self.models[indexPath.row], completion: {
            cell.cellDelegate = self
            cell.acceptButton.tag = indexPath.row
            cell.rejectButton.tag = indexPath.row
            print("cell completion")
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if models[indexPath.row].requestPending == false && models[indexPath.row].requestAccepted == true
        {
            let vc = ChatViewController()
            vc.title = models[indexPath.row].username
            vc.otherUserUID = models[indexPath.row].uid
            vc.otherUserUsername = models[indexPath.row].username
            vc.chatId = chatID(indexPath.row)
            //self.models.remove(at: indexPath.row)
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
        DispatchQueue.main.async
        {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("request").observe(.value) { [self] snapshot in
            //models = [InboxObject]()
            var object = [InboxObject]()
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
                let profilePictureURL = "/images/\(uid)"
                if (requestPending == true && requestAccepted == false)
                {
                   let data = InboxObject(username: username, profilePictureURL: profilePictureURL, message: "Wants to join your trip", uid: uid, requestPending:  requestPending,requestAccepted:requestAccepted)

                    object.append(data)
                }
            }
        
            storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("chats").observe(.value) { [self] snapshot in
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any]
                    else {return}
                    let chatId = res["chatId"] as! String
                    let otherUsername = res["otherUsername"] as! String
                    let otherUserUID = res["otherUserUID"] as! String
                    storageManager.ref.child("Chats").child(chatId).observe(.value) { snapshot2 in
                        guard let value = snapshot2.value as? [String:Any]
                        else {return}
                        let lastMessage = value["last_message"] as! String
                        let data = InboxObject(username: otherUsername, profilePictureURL: storageManager.userProfilePictureString(otherUserUID), message: lastMessage, uid: otherUserUID, requestPending: false, requestAccepted: true)
                            object.append(data)
                        self.models = object
                
                            self.tableView.reloadData()
                        
                        }
                    }
                
                }
            }
        }
    }
    func chatID(_ row:Int) -> String
    {
        var id = String()
        if models[row].username > CurrentUser.Username
        {
            id = CurrentUser.Username + "_" + models[row].username
        }
        else
        {
            id = models[row].username + "_" + CurrentUser.Username
        }
        return id
    }

    
    func didPressAccept(_ tag: Int) {
        let chatId = chatID(tag)
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("request").child(self.models[tag].uid).updateChildValues(["requestAccepted":true, "requestPending":false])
        models[tag].requestPending = false
        models[tag].requestAccepted = true
        //Add chat to other user's inbox
        let otherUserConversationInfo = ["chatId":chatId,"otherUserUID":CurrentUser.UID,"otherUsername":CurrentUser.Username] as [String:Any]
        storageManager.ref.child("User_Inbox").child(self.models[tag].uid).child("chats").child(chatId).setValue(otherUserConversationInfo)
        //Add chat to current user's inbox
        let currentUserConversationInfo = ["chatId":chatId,"otherUserUID":self.models[tag].uid,"otherUsername":self.models[tag].username] as [String:Any]
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("chats").child(chatId).setValue(currentUserConversationInfo)
        tableView.reloadData()
        print("accept button pushed")
    }
    
    func didPressReject(_ tag: Int) {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("request").child(self.models[tag].uid).updateChildValues(["requestAccepted":false, "requestPending":false])
        //models[tag].requestPending = false
        //models[tag].requestAccepted = false
        models.remove(at: tag)
        tableView.reloadData()
        print("reject button pushed")
    }

}
