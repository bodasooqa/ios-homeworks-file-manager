//
//  TextField.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    static func create(title: String, secure: Bool = false) -> UITextField {
        let textField = TextField()
        textField.placeholder = title
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray4.cgColor
        
        if secure {
            textField.isSecureTextEntry = true
        }
        
        return textField
    }
    
}
