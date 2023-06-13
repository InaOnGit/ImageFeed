//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ina on 13/05/2023.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupProfilePictureView() -> UIImageView {
        view.backgroundColor = .black
        
        let profilePicture = UIImage(named: "user_pic")
        let profilePictureView = UIImageView(image: profilePicture)
        profilePictureView.layer.masksToBounds = true
        profilePictureView.layer.cornerRadius = 35
        profilePictureView.tintColor = .gray
        
        profilePictureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePictureView)
        
        return profilePictureView
    }
    
    private func setupNameLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23.0, weight: UIFont.Weight.semibold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        return nameLabel
    }
    
    private func setupLoginLabel() -> UILabel {
        let loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .gray
        loginLabel.font = UIFont.systemFont(ofSize: 13.0)
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        return loginLabel
    }
    
    private func setupMessageLabel() -> UILabel {
        let messageLabel = UILabel()
        messageLabel.text = "Hello, world!"
        messageLabel.font = UIFont.systemFont(ofSize: 13.0)
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        return messageLabel
    }
    
    private func setupLogoutButton() -> UIButton {
        let logoutButton = UIButton.systemButton(
            with: UIImage(named: "logout_pic") ?? UIImage(),
            target: self,
            action: #selector(Self.didTapLogoutButton)
        )
        logoutButton.tintColor = .red
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        return logoutButton
    }
    
    @objc
    private func didTapLogoutButton() {
    }
    
    private func setupViews() {
        let profileImage = setupProfilePictureView()
        let nameLabel = setupNameLabel()
        let loginNameLabel = setupLoginLabel()
        let descriptionLabel = setupMessageLabel()
        let logoutButton = setupLogoutButton()
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            profileImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant:-16),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor)
        ])
    }
}
