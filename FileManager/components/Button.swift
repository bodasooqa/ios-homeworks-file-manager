//
//  Button.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class Button: UIButton {
    
    override var isEnabled: Bool {
        willSet {
            alpha = newValue ? 1 : 0.5
        }
    }
    
    static func create(title: String, outlined: Bool = false, color: UIColor = .systemBlue) -> UIButton {
        let button = Button()
        
        button.setTitle(title, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        
        if outlined {
            button.backgroundColor = .white
            button.layer.borderWidth = 1
            button.layer.borderColor = color.cgColor
            button.setTitleColor(color, for: .normal)
        } else {
            button.backgroundColor = color
        }
        
        return button
    }
    
}
