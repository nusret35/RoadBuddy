//
//  EditProfileViewController.swift
//  RoadBuddy
//
//  Created by Nusret Kızılaslan on 18.03.2022.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    private var tableView:UITableView = {
        let table = UITableView()
        table.register(EditProfileTableViewCell.self, forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        table.backgroundColor = .systemBackground
        return table
    }()
    
    private var headerView:UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyProfilePicture")
        return imageView
    }()
    
    private var changeProfilePictureButton:UIButton =
    {
        let button = UIButton()
        button.setTitle("Change Profile Picture", for: .normal)
        button.setTitleColor(.systemTeal, for: .normal)
        //add button action
        return button
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUpElements()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    func setUpElements()
    {
        setUpTableView()
    }
    
    func setUpTableView()
    {
        let group = DispatchGroup()
        profilePictureImageView.frame = CGRect(x: view.frame.width/2 - 125/2 , y: 30, width: 125, height: 125)
        changeProfilePictureButton.frame = CGRect(x: view.frame.width/2 - 200/2, y: 30+profilePictureImageView.frame.height+10, width: 200, height: 40)
        changeProfilePictureButton.tintColor = .systemTeal
        group.enter()
        storageManager.currentUserProfilePictureLoad { [self] image in
            profilePictureImageView.image = image
            group.leave()
        }
        group.notify(queue: .main) {
            self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width/2
            self.profilePictureImageView.clipsToBounds = true
            self.headerView.addSubview(self.profilePictureImageView)
        }
        headerView.addSubview(changeProfilePictureButton)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as! EditProfileTableViewCell
        //create new custom type cell and make it look good
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    


}
