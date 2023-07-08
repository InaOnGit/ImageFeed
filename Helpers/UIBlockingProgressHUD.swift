//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Ina on 18/06/2023.
//
import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static let shared = UIBlockingProgressHUD()
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.show()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
