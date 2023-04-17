//
//  UILabel+CustomInit.swift
//  ACNetworkObserverDemo
//
//  Created by Damian on 17.04.2023.
//

import UIKit

extension UILabel {
    convenience init(text: String = "", alignment: NSTextAlignment = .left, color: UIColor = .black) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = color
        self.textAlignment = alignment
    }
}
