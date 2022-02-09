//
//  ChatViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 30.01.2022.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId:String
    var sentDate: Date
    var kind: MessageKind
}



struct Sender:SenderType{
    var photoURL: String
    var senderId: String
    var displayName: String
}


class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: currentUser.profilePictureURL, senderId: currentUser.UID, displayName: currentUser.Fullname)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor.defaultBackgroundColor
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
         
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

