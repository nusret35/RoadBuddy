//
//  EditProfileTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 22.03.2022.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell {
    
    static let identifier = "EditProfileTableViewCell"
    
    private var sectionLabel:UILabel =
    {
        let label = UILabel()
        label.textColor = .label
        label.text = "Fullname"
        return label
    }()
    
    private var infoLabel:UILabel =
    {
        let label = UILabel()
        label.textColor = .label
        label.text = "Nusret Kızılaslan"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(sectionLabel)
        contentView.addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionLabel.frame = CGRect(x: 5, y: 0, width: 30, height: contentView.frame.size.height)
        infoLabel.frame = CGRect(x: contentView.frame.size.width-40, y: 0, width: 50, height: contentView.frame.size.height)
    }

}
