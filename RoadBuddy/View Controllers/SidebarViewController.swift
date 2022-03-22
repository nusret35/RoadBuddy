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
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    lazy var homeVC = mainStoryboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
    
    
    var navVC: UINavigationController?
    
    lazy var profilevc = ProfileViewController(nibName:"ProfileViewController",bundle:nil)

    lazy var inboxVC = InboxViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addChildVCs()
        //navVC?.navigationBar.prefersLargeTitles = true
        
    }
    
    
    private func addChildVCs()
    {
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        menuVC.didMove(toParent: self)
        
        //Home
        homeVC.delegate = self
        homeVC.title = "My Trip"
        let navVC = UINavigationController(rootViewController: homeVC)
        navVC.navigationBar.tintColor = .label
        navVC.navigationBar.prefersLargeTitles = true
        addChild(navVC)
        view.addSubview(navVC.view)
        homeVC.didMove(toParent: self)
        self.navVC = navVC
        
        //Profile
        //addProfile()
        
        
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
        case .inbox:
            self.addInbox()
        case .shareApp:
            break
            
        }
            
            
        
        
    }
    
    func addProfile()
    {
        let vc = profilevc
        homeVC.scrollToTop()
        homeVC.title = "Profile"
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }
    
    func resetToHome()
    {
        homeVC.title = "My Trip"
        profilevc.view.removeFromSuperview()
        profilevc.didMove(toParent: nil)
        inboxVC.view.removeFromSuperview()
        inboxVC.didMove(toParent: nil)
        
    }
    
    func addInbox()
    {
        let vc = inboxVC
        homeVC.scrollToTop()
        homeVC.title = "Inbox"
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
    }
}
