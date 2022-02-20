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
    
    var taxiPost = false
    
    @IBOutlet var fromLocationLabel: UILabel!
    @IBOutlet var toLocationLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var numberOfPassengersLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var groundView: UIView!
    @IBOutlet weak var passengerImage: UIImageView!
    
    @IBOutlet weak var arrowImage: UIImageView!
    
    static let identifier = "PostTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        if taxiPost == false
        {
            if traitCollection.userInterfaceStyle == .dark
            {
                groundView.backgroundColor = .secondarySystemBackground
                fromLocationLabel.textColor = .white
                toLocationLabel.textColor = .white
                timeLabel.textColor = .white
                numberOfPassengersLabel.textColor = .white
                priceLabel.textColor = .white
                passengerImage.tintColor = .white
                arrowImage.tintColor = .systemTeal
            }
            else if traitCollection.userInterfaceStyle == .light
            {
                groundView.backgroundColor = .white
                fromLocationLabel.textColor = .midnightBlue
                toLocationLabel.textColor = .midnightBlue
                timeLabel.textColor = .midnightBlue
                numberOfPassengersLabel.textColor = .midnightBlue
                priceLabel.textColor = .midnightBlue
                passengerImage.tintColor = .midnightBlue
                arrowImage.tintColor = .systemTeal
            }
        }
        else
        {
            if traitCollection.userInterfaceStyle == .dark
            {
                groundView.backgroundColor = .systemYellow
                fromLocationLabel.textColor = .white
                toLocationLabel.textColor = .white
                timeLabel.textColor = .white
                numberOfPassengersLabel.isHidden = false
                priceLabel.isHidden = false
                passengerImage.isHidden = false
                arrowImage.tintColor = .systemTeal
            }
            else if traitCollection.userInterfaceStyle == .light
            {
                groundView.backgroundColor = .systemYellow
                fromLocationLabel.textColor = .midnightBlue
                toLocationLabel.textColor = .midnightBlue
                timeLabel.textColor = .midnightBlue
                numberOfPassengersLabel.isHidden = false
                priceLabel.isHidden = false
                passengerImage.isHidden = false
                arrowImage.tintColor = .systemTeal
            }

        }
        groundView.layer.shadowColor = UIColor.black.cgColor
        groundView.layer.shadowOpacity = 1
        groundView.layer.shadowOffset = .zero
        groundView.layer.shadowRadius = 5
        groundView.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        if traitCollection.userInterfaceStyle == .dark
        {
            groundView.backgroundColor = .secondarySystemBackground
            fromLocationLabel.textColor = .white
            toLocationLabel.textColor = .white
            timeLabel.textColor = .white
            numberOfPassengersLabel.textColor = .white
            priceLabel.textColor = .white
            passengerImage.tintColor = .white
            arrowImage.tintColor = .systemTeal
        }
        else if traitCollection.userInterfaceStyle == .light
        {
            groundView.backgroundColor = .white
            fromLocationLabel.textColor = .midnightBlue
            toLocationLabel.textColor = .midnightBlue
            timeLabel.textColor = .midnightBlue
            numberOfPassengersLabel.textColor = .midnightBlue
            priceLabel.textColor = .midnightBlue
            passengerImage.tintColor = .midnightBlue
            arrowImage.tintColor = .systemTeal
        }
        
    }
    
    func configure(with model: TripPost)
    {
        self.fromLocationLabel.text = model.fromLocation
        self.toLocationLabel.text =  model.toLocation
        self.timeLabel.text =  myDateFormat.takeTimeFromStringDate(model.time)
        self.numberOfPassengersLabel.text =  String(model.numberOfPassengers)
        self.priceLabel.text = String(model.price) + " ₺"
        
    }
    
    
}
