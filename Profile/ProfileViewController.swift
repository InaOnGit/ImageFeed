//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Ina on 13/05/2023.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var profilePictureView: UIImageView!
    @IBOutlet private var logOutButton: UIButton!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var loginNameLabel: UILabel!

    @IBAction private func didTapLogOutButton() {
    }
}
