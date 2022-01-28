//
//  TaxiTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 24.01.2022.
//

import UIKit

class TaxiTableViewCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var fromLocationLabel: UILabel!
    @IBOutlet var toLocationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    static let identifier = "TaxiTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "TaxiTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with model: TaxiTripPost)
    {
        self.usernameLabel.text = model.username
        self.userImageView.image = model.profilePicture
        self.fromLocationLabel.text = model.fromLocation
        self.toLocationLabel.text = model.toLocation
        self.timeLabel.text = model.time
    }
    
}
