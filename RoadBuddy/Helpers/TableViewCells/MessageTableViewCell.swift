//
//  MeesageTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 28.01.2022.
//

import UIKit

protocol MessageTableViewCellDelegate: AnyObject
{
    func didPressAccept(_ tag:Int)
    func didPressReject(_ tag:Int)
}

class MessageTableViewCell: UITableViewCell {

    static let identifier = "MessageTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "MessageTableViewCell", bundle: nil)
    }
    
    var cellDelegate:MessageTableViewCellDelegate?
    
    
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var rejectButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
        profilePicture.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(with model: InboxObject)
    {
        self.usernameLabel.text = model.username
        
        self.profilePicture.image = UIImage(named: "emptyProfilePicture")
        
        
        if model.status == "Accepted"
        {
            acceptButton.isHidden = true
            rejectButton.isHidden = true
            messageLabel.text = model.message
        }
        else
        {

            acceptButton.isHidden = false
            rejectButton.isHidden = false
            messageLabel.text = "Wants to join your trip"
        }
        
        storageManager.otherUserProfilePictureLoad(model.uid, completion: { [self] image in
            profilePicture.image = image
            profilePicture.layer.cornerRadius = profilePicture.frame.size.width/2
            profilePicture.clipsToBounds = true
        })
    }
    
    
    
    @IBAction func acceptButtonAction(_ sender: UIButton)
    {
        cellDelegate?.didPressAccept(sender.tag)
    }
    
    @IBAction func rejectButtonAction(_ sender: UIButton)
    
    {
        cellDelegate?.didPressReject(sender.tag)
    }
    
    
    
}
