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

class InboxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageTableViewCellDelegate
{
    private var models = [InboxObject]()
    
    private var idKeys = [String]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //getInboxData()
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
        cell.cellDelegate = self
        cell.acceptButton.tag = indexPath.row
        cell.rejectButton.tag = indexPath.row
        cell.configure(with: models[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if models[indexPath.row].status == "Accepted"
        {
            pushToChatView(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    func getInboxData()
    {
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("Inbox").observe(.value) { [self] snapshot in
            var objects = [InboxObject]()
            for trip in snapshot.children
            {
                let id = trip as! DataSnapshot
                for user in id.children
                {
                    print(id.key)
                    idKeys.append(id.key)
                    let snap = user as! DataSnapshot
                    guard let res = snap.value as? [String:Any]
                    else {return}
                    let otherUsername = res["username"] as! String
                    print(otherUsername)
                    let otherUserUID = res["uid"] as! String
                    let status = res["status"] as! String
                    let lastMessage = res["last_message"] as! String
                    let tripID = res["tripID"] as! String
                    let data = InboxObject(username: otherUsername, profilePictureURL: storageManager.userProfilePictureString(otherUserUID), message: lastMessage, uid: otherUserUID, status: status, tripID:tripID)
                    objects.append(data)
                }
            }
                self.models = objects
                self.tableView.reloadData()
            }
    }
    
    
    func pushToChatView(_ indexPathRow:Int)
    {
        let vc = ChatViewController(tripID: models[indexPathRow].tripID)
        vc.title = models[indexPathRow].username
        vc.otherUserUID = models[indexPathRow].uid
        vc.otherUserUsername = models[indexPathRow].username
        vc.chatId = chatID(indexPathRow)
        //self.models.remove(at: indexPath.row)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
        id = id + "_" + idKeys[row]
        return id
    }
    
    func didPressAccept(_ tag: Int)
    {
        let chatId = chatID(tag)
        var sender = models[tag]
        let idKey = idKeys[tag]
        print(idKey)
        sender.status = "Accepted"
        storageManager.tripRequestAccepted(by: CurrentUser.UID, sender: sender , chatID: chatId,taxiTripID:idKey)
        tableView.reloadData()
        pushToChatView(tag)
    }
    
    func didPressReject(_ tag: Int)
    {
        let alert = UIAlertController(title: "Reject Request?", message: "Do you want to reject this request? You won't be able to undo this.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler:{ action in storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("Inbox").child(self.models[tag].tripID).child(self.models  [tag].uid).updateChildValues(["status":"Rejected"])
            self.models.remove(at: tag)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler:{ action in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert,animated:true)
    }

}
