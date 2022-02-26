//
//  HomeViewController.swift
//  RoadBuddy
//
//  Created by Sabanci on 2022-02-24.
//

import UIKit


protocol HomeViewControllerDelegate: AnyObject
{
    func didTapMenuButton()
}
class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        CurrentUser.fetchData()
        view.backgroundColor = .systemBackground
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(didTapMenuButton))

        
    }
    
    @objc func didTapMenuButton()
    {
        delegate?.didTapMenuButton()
    }
    



}
