//
//  MainViewController.swift
//  FileManager
//
//  Created by t.lolaev on 03.06.2022.
//

import UIKit
import KeychainService

class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    lazy var filesVC = FilesViewController()
    
    lazy var keychainService = KeychainService()
    
    var cachedPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        checkPassword()
    }
    
    private func configureView() {
        view = mainView
        
        mainView.passwordTextField.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
        mainView.acceptButton.addTarget(self, action: #selector(onAcceptTouch), for: .touchUpInside)
    }
    
    private func checkPassword() {
        do {
            if let data = try keychainService.get(recordGetting: KeychainRecordGetting(username: "bodasooqa", service: "my-service")) {
                print(data)
            }
        } catch KeychainServiceError.notFound {
            print("There is no correct data")
        } catch {
            print("Something went wrong")
        }
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
        if let cachedPassword = cachedPassword {
            if let passwordTextFieldText = mainView.passwordTextField.text, passwordTextFieldText == cachedPassword {
                configureTabBar()
                updateAcceptButtonTitle(isEntered: false)
            } else {
                handleError("Incorrect password. Please try again.")
                updateAcceptButtonTitle(isEntered: false)
            }
        } else {
            cachedPassword = mainView.passwordTextField.text
            updateAcceptButtonTitle(isEntered: true)
        }
    }
    
    private func updateAcceptButtonTitle(isEntered: Bool) {
        mainView.acceptButton.setTitle(isEntered ? "Re-enter the password" : "Enter the password", for: .normal)
        resetPasswrodTextFieldText()
        
        if !isEntered {
            cachedPassword = nil
        }
    }
    
    private func resetPasswrodTextFieldText() {
        mainView.passwordTextField.text = ""
        mainView.acceptButton.isEnabled = false
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
    
    private func handleError(_ errorDescription: String) {
        let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
}
