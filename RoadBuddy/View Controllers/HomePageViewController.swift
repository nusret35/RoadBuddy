//
//  HomePageViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 12.12.2021.
//

import UIKit


var NewUser = User()

var profileDataLoad = false

class HomePageViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var SignUpButton: UIButton!
    
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var titlename: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        SignUpButton.setTitle("Sign Up".localized(), for: .normal)
        
        LogInButton.setTitle("Login".localized(), for: .normal)
        
        titlename.text = "Welcome To RoadBuddy".localized()
    }
    @IBAction func signUpAction(_ sender: Any)
    {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "CheckEmailVC") as! CheckEmailViewController
        
        viewController.title = "Enter the E-mail"
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    
}
