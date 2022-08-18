//
//  SettingsViewController.swift.swift
//  FileManager
//
//  Created by t.lolaev on 04.06.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var userDefaults = UserDefaults.standard
    
    private lazy var settingsView = SettingsView()
    
    private lazy var pickerView = UIPickerView()
    
    private lazy var sortOptions = ["From A to Z", "From Z to A"]
    
    private var selectedSortOption: String? {
        didSet {
            guard let selectedSortOption = selectedSortOption else { return }
            
            userDefaults.set(selectedSortOption, forKey: "sort-option")
            settingsView.sortTextField.text = selectedSortOption
            delegate.sortFiles(by: selectedSortOption)
        }
    }
    
    public weak var delegate: FilesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        checkUserDefaults()
    }
    
    private func configureView() {
        view = settingsView
        
        settingsView.resetPasswordButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        
        configurePickerView()
    }
    
    private func configurePickerView() {
        settingsView.sortTextField.inputView = pickerView
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    private func checkUserDefaults() {
        if let sortOption = userDefaults.string(forKey: "sort-option") {
            selectedSortOption = sortOption
            
            if let selectedOptionIndex = sortOptions.firstIndex(of: sortOption) {
                pickerView.selectRow(selectedOptionIndex, inComponent: 0, animated: false)
            }
        } else {
            selectedSortOption = sortOptions[0]
            pickerView.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    @objc private func resetPassword() {
        let mainVC = MainViewController(isModal: true)
        present(mainVC, animated: true)
    }
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sortOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSortOption = sortOptions[row]
        settingsView.sortTextField.resignFirstResponder()
    }

}
