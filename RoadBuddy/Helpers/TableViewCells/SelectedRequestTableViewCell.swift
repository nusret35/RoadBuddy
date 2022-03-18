//
//  SelectedRequestTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 17.03.2022.
//

import UIKit

class SelectedRequestTableViewCell: UITableViewCell {

    static let identifier = "SelectedRequestTableViewCell"
    
    private var usernameLabel: UILabel =
    {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    private var profilePictureImageView: UIImageView =
    {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var statusImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.frame = CGRect(x:0, y: 0, width: 35, height: 35)
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(statusImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let statusImageWidth = contentView.frame.size.height - 10
        
        profilePictureImageView.frame = CGRect(x: 5,
                                               y: 5,
                                               width: contentView.frame.size.height-6,
                                               height: contentView.frame.size.height-6)
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
        profilePictureImageView.clipsToBounds = true
        usernameLabel.frame = CGRect(x:20+profilePictureImageView.frame.size.width,
                                     y:0,
                                     width:contentView.frame.size.width - 10 - statusImageWidth, height: contentView.frame.size.height)
        statusImageView.frame = CGRect(x: contentView.frame.size.width - statusImageWidth, y: 5 , width: statusImageWidth, height: statusImageWidth)
        
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(with request: TemporaryStruct)
    {
        storageManager.otherUserProfilePictureLoad(request.uid) { [self]
            profileImage in
            var imageName = String()
            profilePictureImageView.image = profileImage
            usernameLabel.text = request.username
            if request.status == "Accepted"
            {
                imageName = "status-icon-green"
            }
            else if request.status == "Pending"
            {
                imageName = "status-icon-yellow"
            }
            statusImageView.image = UIImage(named: imageName)
        }
    }
}
