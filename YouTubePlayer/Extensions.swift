//
//  Extensions.swift
//  Nerdologia
//
//  Created by John Lima on 28/12/16.
//  Copyright © 2016 limadeveloper. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    typealias SWColor = UIColor
#else
    import Cocoa
    typealias SWColor = NSColor
#endif

extension SWColor {
    
    /**
     Create non-autoreleased color with in the given hex string
     Alpha will be set as 1 by default
     
     :param:   hexString
     :returns: color with the given hex string
     */
    convenience init?(hexString: Color) {
        self.init(hexString: hexString.rawValue, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex string and alpha
     
     :param:   hexString
     :param:   alpha
     :returns: color with the given hex string and alpha
     */
    convenience init?(hexString: String, alpha: Float) {
        
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
        }
        
        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
            
            // Deal with 3 character Hex strings
            if hex.characters.count == 3 {
                let redHex   = hex.substring(to: hex.index(hex.startIndex, offsetBy: 1))
                let greenHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 1) ..< hex.index(hex.startIndex, offsetBy: 2))
                let blueHex  = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
            let greenHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 2) ..< hex.index(hex.startIndex, offsetBy: 4))
            let blueHex = hex.substring(with: hex.index(hex.startIndex, offsetBy: 4) ..< hex.index(hex.startIndex, offsetBy: 6))
            
            var redInt: CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt: CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    /**
     Create non-autoreleased color with in the given hex value
     Alpha will be set as 1 by default
     
     :param:   hex
     :returns: color with the given hex value
     */
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     
     :param:   hex
     :param:   alpha
     :returns: color with the given hex value and alpha
     */
    public convenience init?(hex: Int, alpha: Float) {
        let hexString = String.localizedStringWithFormat("%2X", hex)
        self.init(hexString: hexString, alpha: alpha)
    }
    
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String.localizedStringWithFormat("#%06x", rgb)
    }
}

extension Collection {
    
    func value(forKeyPath path: String) -> Any? {
        if let dictionary = self as? NSDictionary {
            return dictionary.value(forKeyPath: path)
        }
        return nil
    }
}

