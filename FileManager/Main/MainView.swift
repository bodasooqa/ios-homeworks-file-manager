//
//  MainView.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class MainView: UIView {
    
    public lazy var scrollView: UIScrollView = {
        scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        
        return scrollView
    }()
    
    public lazy var contentView = UIView()
    
    public lazy var passwordTextField: UITextField = TextField(title: "Password", secure: true)
    
    public lazy var acceptButton: UIButton = {
        acceptButton = Button(title: "Enter the password")
        
        acceptButton.setTitle("Password is incorrect", for: .disabled)
        acceptButton.isEnabled = false
        
        return acceptButton
    }()
    
    private var mainChildViews: [UIView] {
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
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        mainChildViews.forEach { subView in
            contentView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 60),
            acceptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 60),

            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.bottomAnchor.constraint(equalTo: acceptButton.topAnchor, constant: -20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}
