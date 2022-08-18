//
//  MainViewController.swift
//  FileManager
//
//  Created by t.lolaev on 03.06.2022.
//

import UIKit
import KeychainService

class MainViewController: UIViewController {
    
    private static let username = "bodasooqa"
    private static let serviceName = "file-manager"
    
    private lazy var mainView = MainView()
    
    lazy var filesVC = FilesViewController()
    lazy var settingsVC = SettingsViewController()
    
    lazy var keychainService = KeychainService()
    
    var cachedPassword: String?
    var passwordFromKeychain: String?
    
    let isModal: Bool
    
    init(isModal: Bool = false) {
        self.isModal = isModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func configureView() {
        view = mainView
        
        mainView.passwordTextField.addTarget(self, action: #selector(onPasswordChange), for: .editingChanged)
        mainView.acceptButton.addTarget(self, action: #selector(onAcceptTouch), for: .touchUpInside)
    }
    
    private func checkPassword() {
        do {
            if let data = try keychainService.get(recordGetting: KeychainRecordGetting(username: Self.username, service: Self.serviceName)) {
                passwordFromKeychain = String(decoding: data, as: UTF8.self)
            }
        } catch KeychainServiceError.notFound {
            handleError("There is no correct data")
        } catch {
            handleError("Something went wrong")
        }
    }
    
    @objc private func onPasswordChange() {
        guard let passwordValue = mainView.passwordTextField.text else { return }
        
        if passwordValue.count >= 4 {
            mainView.acceptButton.isEnabled = true
        } else {
            mainView.acceptButton.isEnabled = false
        }
    }
    
    @objc private func onAcceptTouch() {
        if let cachedPassword = cachedPassword {
            if let passwordTextFieldText = mainView.passwordTextField.text, passwordTextFieldText == cachedPassword {
                if isModal {
                    resetPassword()
                } else {
                    checkPassword()
                    
                    if let passwordFromKeychain = passwordFromKeychain {
                        if passwordFromKeychain == passwordTextFieldText {
                            logIn()
                        } else {
                            rejectLogIn()
                        }
                    } else {
                        logIn(withSave: true)
                    }
                }
            } else {
                rejectLogIn()
            }
        } else {
            cachedPassword = mainView.passwordTextField.text
            updateAcceptButtonTitle(isEntered: true)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = mainView.scrollView.contentInset
        let acceptButtonBottomOffset = mainView.frame.height - mainView.acceptButton.frame.maxY
        
        if acceptButtonBottomOffset < keyboardFrame.size.height {
            let bottomContentInset = keyboardFrame.size.height - acceptButtonBottomOffset + 40
            contentInset.bottom = bottomContentInset
            mainView.scrollView.contentInset = contentInset
            mainView.scrollView.setContentOffset(CGPoint(x: 0, y: bottomContentInset), animated: true)
        }
    }
    
    @objc private func keyboardWillHide() {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        mainView.scrollView.contentInset = contentInset
    }
    
    private func updateAcceptButtonTitle(isEntered: Bool) {
        mainView.acceptButton.setTitle(isEntered ? "Re-enter the password" : "Enter the password", for: .normal)
        resetPasswrodTextFieldText()
        
        if !isEntered {
            cachedPassword = nil
        }
    }
    
    private func logIn(withSave: Bool? = false) {
        if let withSave = withSave, withSave {
            savePassword()
        }
        
        configureTabBar()
        updateAcceptButtonTitle(isEntered: false)
    }
    
    private func resetPassword() {
        if let cachedPassword = cachedPassword {
            do {
                try keychainService.update(record: KeychainRecord(username: Self.username, service: Self.serviceName, password: cachedPassword))
                dismiss(animated: true)
            } catch {
                handleError("KeychainService error: \"\(error)\"")
            }
            
        }
    }
    
    private func rejectLogIn() {
        handleError("Incorrect password. Please try again.")
        updateAcceptButtonTitle(isEntered: false)
    }
    
    private func resetPasswrodTextFieldText() {
        mainView.passwordTextField.text = ""
        mainView.acceptButton.isEnabled = false
    }
    
    private func savePassword() {
        if let cachedPassword = cachedPassword {
            do {
                try keychainService.save(record: KeychainRecord(username: Self.username, service: Self.serviceName, password: cachedPassword))
            } catch KeychainServiceError.duplicate {
                handleError("The password already exists")
            } catch KeychainServiceError.passToData {
                handleError("Data conversion error")
            } catch {
                handleError("KeychainService error: \"\(error)\"")
            }
        }
    }
    
    private func configureTabBar() {
        let tabBarVC = UITabBarController()
        let filesNavVC = UINavigationController(rootViewController: filesVC)
        let settingsNavVC = UINavigationController(rootViewController: settingsVC)
        
        filesVC.title = "File Manager"
        settingsVC.title = "Settings"
        
        filesNavVC.tabBarItem.image = UIImage(systemName: "house")
        settingsNavVC.tabBarItem.image = UIImage(systemName: "gear")
        
        settingsVC.delegate = filesVC
        
        tabBarVC.setViewControllers([filesNavVC, settingsNavVC], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.pushViewController(tabBarVC, animated: true)
    }
    
    private func handleError(_ errorDescription: String) {
        let alert = UIAlertController(title: "Error", message: errorDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true)
    }
    
}
