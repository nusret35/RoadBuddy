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
    
    @IBOutlet weak var settingsButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        CurrentUser.fetchData {
            
        }
        setUpElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        settingsButton.isUserInteractionEnabled = true
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
    
    
    @IBAction func settingsButtonAction(_ sender: Any)
    {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
        settingsButton.isUserInteractionEnabled = false
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any)
    {
        let vc = EditProfileViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.title = "Edit Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
}
