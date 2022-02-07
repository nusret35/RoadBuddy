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
    
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Nusret Ali Kızılaslan")
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor.defaultBackgroundColor
        /*
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
         */
    }
    
}
/*
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate
{
    func currentSender() -> SenderType
    {
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    
}
*/
