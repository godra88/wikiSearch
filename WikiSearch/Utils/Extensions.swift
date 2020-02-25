//
//  Extensions.swift
//  WikiSearch
//
//  Created by Ivan Fabri on 2/18/20.
//  Copyright © 2020 Ivan Fabri. All rights reserved.
//

import UIKit

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}

extension URLComponents{
    var queryItemsDictionary : [String:Any]{
        set (queryItemsDictionary){
            self.queryItems = queryItemsDictionary.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
        }
        get{
            var params = [String: Any]()
            return queryItems?.reduce([:], { (_, item) -> [String: Any] in
                params[item.name] = item.value
                return params
            }) ?? [:]
        }
    }
}

extension UIView {
    
    func anchor(top:NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight:CGFloat = 0,
                width:CGFloat? = nil,
                height:CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView) {
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UIColor {
    static let customBlue = UIColor(red:0.31, green:0.82, blue:0.76, alpha:1.0)
    static let customYeallow = UIColor(red:0.96, green:0.65, blue:0.13, alpha:1.0)
    static let customLightBlue = UIColor(red:0.92, green:0.98, blue:0.97, alpha:1.0)
}

extension UIViewController {
    func showAlert(title:String, message:String, timeInterval: Double) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
        }
    }
}
