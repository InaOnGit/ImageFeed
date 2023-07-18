//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Ina on 29/06/2023.
//
import UIKit

final class AlertPresenter {
    weak var delegate: UIViewController?
    
    func showAlert(title: String, message: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true)
    }
    
    func showLikeAlert(title: String, message: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось поставить лайк", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Okay", style: .default) { _ in
            handler()
        }
        alert.addAction(alertAction)
        delegate?.present(alert, animated: true)
    }
}
