//
//  FirstViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 8.02.2022.
//

import UIKit
import FirebaseAuth

var currentUser = CurrentUserData()

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        currentUser.fetchData()
    }
    
    
    
    func authenticateUser()
    {
        if Auth.auth().currentUser == nil
        {
        DispatchQueue.main.async
            {
                
                let homePageNavigationController = self.registrationStoryboard.instantiateViewController(withIdentifier: "HomePageNC") as! UINavigationController
                self.present(homePageNavigationController, animated: true, completion: nil)
            }
        }
    }

}
