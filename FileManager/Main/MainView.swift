//
//  MainView.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class MainView: UIView {
    
    public lazy var passwordTextField: UITextField = {
        passwordTextField = TextField()
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemGray4.cgColor
        
        return passwordTextField
    }()
    
    public lazy var acceptButton: UIButton = {
        acceptButton = Button()
        acceptButton.setTitle("Enter the password", for: .normal)
        acceptButton.setTitle("Password is incorrect", for: .disabled)
        acceptButton.isEnabled = false
        acceptButton.backgroundColor = .systemBlue
        acceptButton.layer.masksToBounds = true
        acceptButton.layer.cornerRadius = 10
        
        return acceptButton
    }()
    
    private var subViews: [UIView] {
        [passwordTextField, acceptButton]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .white
        
        subViews.forEach { subView in
            addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            passwordTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
            
            acceptButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            acceptButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}
