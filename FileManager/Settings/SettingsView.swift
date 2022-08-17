//
//  SettingsView.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class SettingsView: UIView {
    
    public lazy var sortTextField: UITextField = {
        sortTextField = TextField.create(title: "Sort")
        
        return sortTextField
    }()
    
    public lazy var resetPasswordButton: UIButton = {
        resetPasswordButton = Button(title: "Reset the password", outlined: true, color: .systemRed)
        
        return resetPasswordButton
    }()
    
    private var subViews: [UIView] {
        [sortTextField, resetPasswordButton]
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
            sortTextField.topAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            sortTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sortTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sortTextField.heightAnchor.constraint(equalToConstant: 60),
            
            resetPasswordButton.topAnchor.constraint(equalTo: sortTextField.bottomAnchor, constant: 20),
            resetPasswordButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            resetPasswordButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
}
