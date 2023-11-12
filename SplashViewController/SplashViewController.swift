//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Ina on 09/06/2023.
//
import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let authService = OAuth2Service.shared
    private let authToken = OAuth2TokenStorage.shared
    private let alertPresenter = AlertPresenter()
    private let showLoginFlowSegueIdentifier = "ShowLoginFlow"
    
    private let backgroungImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector") ?? UIImage(named: "Vector")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        view.backgroundColor = .yp_black
        
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkAuthStatus()
    }
    
    private func layout() {
        view.addSubview(backgroungImage)
        backgroungImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroungImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroungImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func checkAuthStatus() {
        if let token = authToken.token {
            //UIBlockingProgressHUD.show()
            self.fetchProfile(token: token)
        } else {
            showAuthController()
        }
    }
    
    private func showAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard
            .instantiateViewController(withIdentifier: "AuthViewControllerID") as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(authViewController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration: No window found") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        authService.fetchOAuthToken(code) { [weak self] authResult in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch authResult {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] profileResult in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else {
                return
                
            }
            switch profileResult {
            case .success(_):
                if let user = self.profileService.profile?.username {
                    self.profileImageService.fetchProfileImageURL(userName: user) { _ in }
                }
                
                self.switchToTabBarController()
            case .failure(let error):
                self.showLoginAlert(error: error)
            }
        }
    }
    
    private func showLoginAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так",
                                 message: "Не удалось войти в систему, \(error.localizedDescription)") { [weak self] in
            
            self?.showAuthController()
        }
    }
}
