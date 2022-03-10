//
//  ChatViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 30.01.2022.
//

import UIKit
import MessageKit
import FirebaseDatabase
import InputBarAccessoryView

struct Message: MessageType
{
    var sender: SenderType
    var messageId:String
    var sentDate: Date
    var kind: MessageKind
}



struct Sender:SenderType
{
    var photoURL: String
    var senderId: String
    var displayName: String
}


class ChatViewController: MessagesViewController
{
    var otherUserUID = String()
    
    var otherUserUsername = String()
    
    var chatId = String()
    
    private var tripID = String()
    
    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: CurrentUser.profilePictureURL, senderId: CurrentUser.UID, displayName: CurrentUser.Fullname)
    
    init(tripID:String)
    {
        self.tripID = tripID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        getMessages()
        //listenForMessages()
        //messagesCollectionView.reloadData()
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    
    
    func getMessages()
    {
        storageManager.ref.child("Chats").child(self.chatId).child("messages").observe(.value){ [self] snapshot in
            var loadedMessages = [Message]()
            if snapshot.exists() == true
            {
                for child in snapshot.children
                {
                    let snap = child as! DataSnapshot
                    guard let res = snap.value as? [String:Any] else {return}
                    //let messageId = res["messageId"] as! String
                    let date = res["sendDate"] as! String
                    let messageText = res["text"] as! String
                    let senderUID = res["senderUID"] as! String
                    var sender = Sender(photoURL: "", senderId: "", displayName: "")
                    if senderUID == CurrentUser.UID
                    {
                        sender = selfSender
                    }
                    else
                    {
                        sender = Sender(photoURL: CurrentUser.profilePictureURL, senderId: otherUserUID, displayName: otherUserUsername)
                    }
                    let storedMessage = Message(sender: sender, messageId: createMessageId(), sentDate: myDateFormat.stringToMessageDate(date), kind: .text(messageText))
                    loadedMessages.append(storedMessage)
                }
                
                messages = sortMessages(loadedMessages)
                messagesCollectionView.reloadData()
                messagesCollectionView.layoutIfNeeded()
            }
            
        }

    }
    /*
    func listenForMessages()
    {
        DispatchQueue.main.async
        {
            self.getMessages()
        }
    }*/
    
    func sortMessages(_ messages:[Message]) -> [Message]
    {
        var loadedMessages = messages
        var sortedMessages:[Message] = []
        while loadedMessages.isEmpty == false
        {
            var date1 = loadedMessages[0].sentDate
           // print(myDateFormat.messageDateToString(date1))
            var date1_index = 0
            if (loadedMessages.count != 1)
            {
                for temp in 0...loadedMessages.count-1
                {
                    let date2 = loadedMessages[temp].sentDate
                    if date2 < date1
                    {
                        date1_index = temp
                        date1 = date2
                    }
                }
            }
            sortedMessages.append(loadedMessages[date1_index])
            while date1_index != loadedMessages.count-1
            {
                loadedMessages[date1_index] = loadedMessages[date1_index+1]
                date1_index+=1
            }
            let dummy = loadedMessages.popLast()
        }
        return sortedMessages
    }

}
extension ChatViewController: InputBarAccessoryViewDelegate
{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String){
        print("Sending: \(text)")
        //Send message
        
        let message = Message(sender: selfSender, messageId: createMessageId(), sentDate: myDateFormat.secondsInFormat(Date())!, kind: .text(text))
        
        let messageForFirebase = ["messageId":message.messageId,"sendDate":myDateFormat.returnMessageTime(),"text":text,"senderUID":message.sender.senderId,"senderUsername":message.sender.displayName] as [String : Any]
        storageManager.ref.child("Chats").child(chatId).child("messages").child(message.messageId).setValue(messageForFirebase)
        storageManager.ref.child("Chats").child(chatId).child("last_message").setValue(text)
        storageManager.ref.child("User_Inbox").child(CurrentUser.UID).child("Inbox").child(tripID).child(otherUserUID).child("last_message").setValue(text)
        storageManager.ref.child("User_Inbox").child(otherUserUID).child("Inbox").child(tripID).child(CurrentUser.UID).child("last_message").setValue(text)
        messages.append(message)
        messagesCollectionView.reloadDataAndKeepOffset()
        messagesCollectionView.layoutIfNeeded()
        messageInputBar.inputTextView.text = ""
        //storageManager.ref.child
    }

    private func createMessageId() -> String
    {
        let newIdentifier = "\(chatId)_\(myDateFormat.returnMessageTime())"
        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate
{
    func currentSender() -> SenderType
    {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

