//
//  UIFontExtension.swift
//  Fans Match Center
//
//  Created by Rifat Firdaus on 6/22/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit

enum ProximaNovaStyle {
    case extraBold
    case light
    case black
    case semiBold
    case blackItalic
    case thinItalic
    case regularItalic
    case extraBoldItalic
    case boldItalic
    case thin
    case bold
    case semiBoldItalic
    case regular
    case lightItalic
}

extension UIFont {

    //Family: Proxima Nova Font names: ["ProximaNova-Extrabld", "ProximaNova-Light", "ProximaNova-Black", "ProximaNova-Semibold", "ProximaNova-BlackIt", "ProximaNova-ThinIt", "ProximaNova-RegularIt", "ProximaNova-ExtrabldIt", "ProximaNova-BoldIt", "ProximaNovaT-Thin", "ProximaNova-Bold", "ProximaNova-SemiboldIt", "ProximaNova-Regular", "ProximaNova-LightIt"]
    
    static func ProximaNova(size: CGFloat?, style: ProximaNovaStyle? = nil) -> UIFont {
        var fontSize:CGFloat = 12
        if let size = size {
            fontSize = size
        }
        if let style = style {
            switch style {
            case .extraBold:
                return UIFont(name: "ProximaNova-Extrabld", size: fontSize)!
            case .light:
                return UIFont(name: "ProximaNova-Light", size: fontSize)!
            case .black:
                return UIFont(name: "ProximaNova-Black", size: fontSize)!
            case .semiBold:
                return UIFont(name: "ProximaNova-Semibold", size: fontSize)!
            case .blackItalic:
                return UIFont(name: "ProximaNova-BlackIt", size: fontSize)!
            case .thinItalic:
                return UIFont(name: "ProximaNova-ThinIt", size: fontSize)!
            case .regularItalic:
                return UIFont(name: "ProximaNova-RegularIt", size: fontSize)!
            case .extraBoldItalic:
                return UIFont(name: "ProximaNova-ExtrabldIt", size: fontSize)!
            case .boldItalic:
                return UIFont(name: "ProximaNova-BoldIt", size: fontSize)!
            case .thin:
                return UIFont(name: "ProximaNovaT-Thin", size: fontSize)!
            case .bold:
                return UIFont(name: "ProximaNova-Bold", size: fontSize)!
            case .semiBoldItalic:
                return UIFont(name: "ProximaNova-SemiboldIt", size: fontSize)!
            case .regular:
                return UIFont(name: "ProximaNova-Regular", size: fontSize)!
            case .lightItalic:
                return UIFont(name: "ProximaNova-LightIt", size: fontSize)!
            }
        }
        
        return UIFont(name: "ProximaNova-Regular", size: fontSize)!
    }
    
}
