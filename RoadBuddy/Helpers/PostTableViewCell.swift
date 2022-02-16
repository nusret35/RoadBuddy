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
    
    
    @IBOutlet var fromLocationLabel: UILabel!
    @IBOutlet var toLocationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var numberOfPassengersLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var groundView: UIView!
    
    
    static let identifier = "PostTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        BackgroundColor.setTableViewCellBackgroundColor(groundView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: TripPost)
    {
        self.fromLocationLabel.text = model.fromLocation
        self.toLocationLabel.text =  model.toLocation
        self.timeLabel.text =  model.time
        self.numberOfPassengersLabel.text =  String(model.numberOfPassengers)
        self.priceLabel.text = String(model.price)
        
    }
    
    
}
