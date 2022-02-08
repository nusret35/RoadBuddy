//
//  FirstTableViewCell.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-08.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    static let identifier = "FirstTableViewCell"

    static func nib() -> UINib
    {
        return UINib(nibName: "FirstTableViewCell", bundle: nil)
    }
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
