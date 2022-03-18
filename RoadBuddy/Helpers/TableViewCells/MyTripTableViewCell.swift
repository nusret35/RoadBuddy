//
//  MyTripTableViewCell.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 27.02.2022.
//

import UIKit

class MyTripTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var passengerButton: UIButton!
    
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var groundView: UIView!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    static let identifier = "MyTripTableViewCell"
    
    static func nib() -> UINib
    {
        return UINib(nibName: "MyTripTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //typeImage.isHidden = true
        giveShadowToGroundView()
    }
    
    func giveShadowToGroundView()
    {
        groundView.layer.shadowColor = UIColor.black.cgColor
        groundView.layer.shadowOpacity = 1
        groundView.layer.shadowOffset = .zero
        groundView.layer.shadowRadius = 5
        groundView.layer.shouldRasterize = true
        groundView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func configure(with model:Request)
    {
        timeLabel.text = myDateFormat.takeTimeFromStringDate(model.date)
        fromLabel.text = model.from
        toLabel.text = model.to
        statusLabel.text = model.status
        if model.status == "Searching" 
        {
            statusImageView.image = UIImage(named: "status-icon-teal")
        }
        else if model.status == "Accepted"
        {
            statusImageView.image = UIImage(named: "status-icon-green")
        }
        else if model.status == "Pending"
        {
            statusImageView.image = UIImage(named: "status-icon-yellow")

        }
        else if model.status == "Rejected"
        {
            statusImageView.image = UIImage(named: "status-icon-red")
        }
        if model.type == "Trip Request"
        {
            typeLabel.text = "Trip Request"
            passengerButton.setTitle(String(model.passengerNumber), for: .normal)
            passengerButton.isHidden = false
            //typeImage.image = UIImage(systemName: "figure.wave")
        }
        else if model.type == "Trip Post"
        {
            typeLabel.text = "Trip Post"
            passengerButton.setTitle(String(model.passengerNumber), for: .normal)
            passengerButton.isHidden = false
            //typeImage.image = UIImage(systemName: "car.fill")
        }
        else if model.type == "Taxi Request"
        {
            typeLabel.text = "Taxi Request"
            //typeImage.image = UIImage(named: "type-icon-taxi")
            passengerButton.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
