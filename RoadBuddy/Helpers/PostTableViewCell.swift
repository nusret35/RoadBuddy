//
//  PostTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 22.12.2021.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject
{
    func didPressButton()
}

class PostTableViewCell: UITableViewCell {

    var cellDelegate: PostTableViewCellDelegate?
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fromLocationLabel: UILabel!
    @IBOutlet var toLocationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var numberOfPassengersLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    static let identifier = "PostTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: TripPost)
    {
        self.usernameLabel.text = model.username
        self.userImageView.image = model.profilePicture
        self.fromLocationLabel.text = model.fromLocation
        self.toLocationLabel.text =  model.toLocation
        self.timeLabel.text =  model.time
        self.numberOfPassengersLabel.text =  String(model.numberOfPassengers)
        self.priceLabel.text = model.price
        
    }
    
    
}
