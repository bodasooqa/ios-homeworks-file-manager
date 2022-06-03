//
//  MainViewController.swift
//  FileManager
//
//  Created by t.lolaev on 03.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    lazy var filesVC = FilesViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        view = mainView
        
        mainView.passwordTextField.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
        mainView.acceptButton.addTarget(self, action: #selector(onAcceptTouch), for: .touchUpInside)
    }
    
    @objc private func onPasswordChange() {
        if let passwordValue = mainView.passwordTextField.text {
            if passwordValue.count >= 4 {
                mainView.acceptButton.isEnabled = true
            } else {
                mainView.acceptButton.isEnabled = false
            }
        }
    }
    
    @objc private func onAcceptTouch() {
        configureTabBar()
    }
    
    private func configureTabBar() {
        let tabBarVC = UITabBarController()
        let filesNavVC = UINavigationController(rootViewController: filesVC)
        let settingsNavVC = UINavigationController(rootViewController: UIViewController())
        
        filesNavVC.tabBarItem.image = UIImage(systemName: "house")
        settingsNavVC.tabBarItem.image = UIImage(systemName: "gear")
        
        tabBarVC.setViewControllers([filesNavVC, settingsNavVC], animated: true)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
}
