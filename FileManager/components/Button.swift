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
    
}
