//
//  UIColors_extensions.swift
//  ImageFeed
//
//  Created by Ina on 20/05/2023.
//

import Foundation
import UIKit

extension UIColor {
    static var yp_backgroung: UIColor { UIColor(named: "yp_background") ?? .darkGray}
    static var yp_black: UIColor { UIColor(named: "yp_black") ?? .black}
    static var yp_blue: UIColor { UIColor(named: "yp_bleu") ?? .blue}
    static var yp_gray: UIColor { UIColor(named: "yp_gray") ?? .gray}
    static var yp_red: UIColor { UIColor(named: "yp_red") ?? .red}
    static var yp_white_alpha: UIColor { UIColor(named: "yp_white_alpha") ?? .white.withAlphaComponent(0.5)}
    static var yp_white: UIColor { UIColor(named: "yp_white") ?? .white}
}
