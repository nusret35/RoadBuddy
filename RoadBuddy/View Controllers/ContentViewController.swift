//
//  ContentViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 4.04.2022.
//

import UIKit


class ContentViewController: UIViewController {
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Current Trip"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let fromLabel:UIButton = {
        let button = UIButton()
        button.setTitle("From: ", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    
    let toLabel:UIButton = {
        let button = UIButton()
        button.setTitle("To: ", for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        return button
    }()
    
    let priceLabel:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "dollarsign.circle"), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tintColor = .label
        return button
    }()
    
    let passengerLabel:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.3"), for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.tintColor = .label
        return button
    }()

    let finishTripButton:UIButton =
    {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Finish", for: .normal)
        button.layer.cornerRadius = 10
        button.isUserInteractionEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(fromLabel)
        view.addSubview(toLabel)
        view.addSubview(priceLabel)
        view.addSubview(passengerLabel)
        view.addSubview(finishTripButton)
    }
    
    override func viewDidLayoutSubviews() {
        titleLabel.frame = CGRect(x: 10, y: 20, width: view.frame.width, height: 35)
        fromLabel.frame = CGRect(x: 10, y: 20+titleLabel.frame.size.height+20, width: view.frame.size.width-20, height: 60)
        toLabel.frame = CGRect(x: 10, y: 20+titleLabel.frame.size.height+20+fromLabel.frame.size.height+20, width: view.frame.size.width-20, height: 60)
        priceLabel.frame = CGRect(x: 10, y: 20+titleLabel.frame.size.height+20+fromLabel.frame.size.height+20+toLabel.frame.size.height+20, width: (view.frame.size.width-30)/2, height: 60)
        passengerLabel.frame = CGRect(x: priceLabel.frame.size.width+20, y: 20+titleLabel.frame.size.height+20+fromLabel.frame.size.height+20+toLabel.frame.size.height+20, width: (view.frame.size.width-30)/2, height: 60)
        finishTripButton.frame = CGRect(x: 10, y: 20+titleLabel.frame.size.height+20+fromLabel.frame.size.height+20+toLabel.frame.size.height+20+priceLabel.frame.size.height+20, width: view.frame.size.width-20, height: 50)
    }
    
}
