//
//  UIViewController+Additions.swift
//  Soundrenaline
//
//  Created by Wito Chandra on 13/07/16.
//  Copyright © 2016 Suitmedia. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupNavRightItem(target: Any? = nil, icon: String, selector: Selector) {
        var items = [UIBarButtonItem]()
        let _target = target == nil ? self : target
        let barButtonItemClose = UIBarButtonItem(image: UIImage(named: icon), style: .plain, target: _target, action: selector)
        barButtonItemClose.tintColor = UIColor.white
        items.append(barButtonItemClose)
        navigationItem.rightBarButtonItems = nil
        navigationItem.rightBarButtonItems = items
    }
    
    func setupMainNavbar(withTitle title: String? = nil) {
        if let title = title {
            // no change if nil
            navigationItem.title = title
        }
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 13, green: 95, blue: 167)
        navigationController?.navigationBar.setGradientBackground(colors: [UIColor(red: 239, green: 83, blue: 80), UIColor(red: 244, green: 67, blue: 54)])
    }
    
    // MARK: SELECTOR
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer?) {
        view.endEditing(true)
        
        if let searchBar = navigationItem.titleView, let searchTextField = searchBar.value(forKey: "searchField") as? UITextField, searchTextField.isEditing {
            searchBar.resignFirstResponder()
        }
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += self.frame.origin.y
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
    
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 0)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
