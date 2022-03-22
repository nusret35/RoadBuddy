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
        return label
    }()
    
    private var infoLabel:UILabel =
    {
        let label = UILabel()
        label.textColor = .label
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
        
        sectionLabel.frame = CGRect(x: 10, y: 0, width: 120, height: contentView.frame.size.height)
        infoLabel.frame = CGRect(x: contentView.frame.size.width-150, y: 0, width: 150, height: contentView.frame.size.height)
    }
    
    func configure(indexPathRow:Int)
    {
        if indexPathRow == 0
        {
            sectionLabel.text = "Fullname"
            infoLabel.text = CurrentUser.Fullname
        }
        else if indexPathRow == 1
        {
            sectionLabel.text = "Username"
            infoLabel.text = CurrentUser.Username
        }
        else if indexPathRow == 2
        {
            sectionLabel.text = "Email"
            infoLabel.text = CurrentUser.Email
        }
        else if indexPathRow == 3
        {
            sectionLabel.text = "Phone Number"
            infoLabel.text = "+90" + CurrentUser.PhoneNumber
        }
    }

}
