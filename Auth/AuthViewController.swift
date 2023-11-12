//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ina on 28/05/2023.
//
import Foundation
import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController {
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            if let webViewViewController = segue.destination as? WebViewViewController {
                webViewViewController.delegate = self
            } else {
                assertionFailure("Failed to prepare for \(showWebViewSegueIdentifier)")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
            self.delegate?.authViewController(self, didAuthenticateWithCode: code)
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
