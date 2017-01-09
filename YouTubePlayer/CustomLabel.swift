//
//  CustomLabel.swift
//  Nerdologia
//
//  Created by John Lima on 08/01/17.
//  Copyright © 2017 limadeveloper. All rights reserved.
//

import UIKit

@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable
    var masksToBounds: Bool = true {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var backColor: UIColor = UIColor.clear {
        didSet {
            backgroundColor = backColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var leftEdge: CGFloat = 0.0
    @IBInspectable var rightEdge: CGFloat = 0.0
    @IBInspectable var topEdge: CGFloat = 0.0
    @IBInspectable var bottomEdge: CGFloat = 0.0
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topEdge, left: leftEdge, bottom: bottomEdge, right: rightEdge)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

}
