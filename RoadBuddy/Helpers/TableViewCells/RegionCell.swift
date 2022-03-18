//
//  TableViewCell.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-21.
//

import UIKit

class RegionCell: UITableViewCell {

    @IBOutlet weak var regionText: UILabel!
    
    @IBOutlet weak var regionNumberCodeText: UILabel!
    
    static let identifier = "RegionCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "RegionCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
