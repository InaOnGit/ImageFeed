//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Ina on 28/05/2023.
//

import Foundation
import UIKit

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = String("ShowWebView")
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_vc: WebViewViewController, didAuthenticateWithCode code: String) {
        // code to add
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
