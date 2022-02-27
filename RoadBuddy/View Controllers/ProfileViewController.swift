//
//  ProfileViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 26.02.2022.
//

import UIKit
import SkeletonView


class ProfileViewController: UIViewController {

    
    @IBOutlet weak var fullnameLabel: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        CurrentUser.fetchData()
        setUpElements()
        
    }
    
    func setUpElements()
    {
        setSkeletonView()
        setLabelText()
        profilePictureSet()
        hideSkeletonView()
    }

    func setSkeletonView()
    {
        fullnameLabel.isSkeletonable = true
        usernameLabel.isSkeletonable = true
        fullnameLabel.showAnimatedGradientSkeleton()
        usernameLabel.showAnimatedGradientSkeleton()
    }
    
    func setLabelText()
    {
        fullnameLabel.text = CurrentUser.Fullname
        usernameLabel.text = CurrentUser.Username
    }
    
    func profilePictureSet()
    {
        if CurrentUser.profilePictureIsSet
        {
            print("there exist a pp")
            storageManager.currentUserProfilePictureLoad { [self] image in
                profilePictureImageView.image = image
                profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.size.width/2
                profilePictureImageView.clipsToBounds = true
            }
        }
        else
        {
            profilePictureImageView.image = UIImage(named: "emptyProfilePicture")
        }
    }
    
    func hideSkeletonView()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute:{ [self] in
            fullnameLabel.hideSkeleton()
            usernameLabel.hideSkeleton()
        })
    }
    
}
