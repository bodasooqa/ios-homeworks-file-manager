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
    
    required init(title: String, outlined: Bool = false, color: UIColor = .systemBlue) {
        super.init(frame: .zero)
         
        setTitle(title, for: .normal)
        layer.masksToBounds = true
        layer.cornerRadius = 10
        
        if outlined {
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = color.cgColor
            setTitleColor(color, for: .normal)
        } else {
            backgroundColor = color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
