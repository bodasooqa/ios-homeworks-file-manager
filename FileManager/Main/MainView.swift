//
//  MainView.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class MainView: UIView {
    
    public lazy var passwordTextField: UITextField = {
        passwordTextField = TextField.create(title: "Password", secure: true)
        
        return passwordTextField
    }()
    
    public lazy var acceptButton: UIButton = {
        acceptButton = Button.create(title: "Enter the password")
        
        acceptButton.setTitle("Password is incorrect", for: .disabled)
        acceptButton.isEnabled = false
        
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
