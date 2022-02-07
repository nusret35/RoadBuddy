//
//  ChatViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 30.01.2022.
//

import UIKit
import MessageKit

struct Message
{
    var text:String
}

class ChatViewController: MessagesViewController {

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = BackgroundColor.defaultBackgroundColor
    }
    
}
/*
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate
{
    func currentSender() -> SenderType {
        <#code#>
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        <#code#>
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    
}
 */
