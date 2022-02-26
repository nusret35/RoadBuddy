//
//  SidebarViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-24.
//

import UIKit

class SidebarViewController: UIViewController
{
    
    enum MenuStates
    {
        case opened
        case closed
    }
    
    private var menuState: MenuStates = .closed
    
    let menuVC = MenuViewController()
    let homeVC = HomeViewController()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var navVC: UINavigationController?
    
    lazy var profilevc = mainStoryboard.instantiateViewController(withIdentifier: "ProfilePageVC") as! ProfilePageViewController
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVCs()
        
    }
    
    
    private func addChildVCs()
    {
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        //Home
        homeVC.delegate = self
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.navigationBar.prefersLargeTitles = true
        addChild(navVC)
        view.addSubview(navVC.view)
        homeVC.didMove(toParent: self)
        self.navVC = navVC
        
        
        
    }
    
    

    

}

extension SidebarViewController: HomeViewControllerDelegate
{
    func didTapMenuButton()
    {
        toggleMenu(completion: nil)
        
        

    }
    
    func toggleMenu(completion: (() -> Void)?)
    {
        switch menuState
        {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.navVC?.view.frame.origin.x = self.homeVC.view.frame.size.width - 100
                
            } completion: { [weak self] done in
                if done
                {
                    self?.menuState = .opened
                }
            }

        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                
                self.navVC?.view.frame.origin.x = 0
                
            } completion: { [weak self] done in
                if done
                {
                    self?.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}

extension SidebarViewController: MenuViewControllerDelegate
{
    func didSelect(menuItem: MenuViewController.MenuOptions) {
        toggleMenu(completion: nil)
        switch menuItem
        {
            
        case .home:
            self.resetToHome()
        case .profile:
            self.addProfile()
        case .appRating:
            break
        case .shareApp:
            break
        case .settings:
            break
        }
        
            
            
            
        
        
    }
    
    func addProfile()
    {
        let vc = profilevc
        vc.title = "Profile"
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }
    
    func resetToHome()
    {
        profilevc.view.removeFromSuperview()
        profilevc.didMove(toParent: nil)
        homeVC.title = "My Trip"
        
    }
}
