//
//  UIViewControllerExtension.swift
//  RandomBeerPicker
//
//  Created by 강민혜 on 8/3/22.
//

import Foundation
import UIKit

extension UIViewController {

    func setBackgroundColor() {
        view.backgroundColor = .brown
    }
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
