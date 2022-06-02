//
//  MainViewController.swift
//  FileManager
//
//  Created by t.lolaev on 02.06.2022.
//

import UIKit
import Photos
import PhotosUI
import FileManagerService

class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    private lazy var fileManagerService: FileManagerService = .shared
    
    private var files: [URL] {
        fileManagerService.files
    }
    
    lazy var pickerConfiguration: PHPickerConfiguration = {
        pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfiguration.selectionLimit = 3
        pickerConfiguration.filter = .images
        
        return pickerConfiguration
    }()
    
    lazy var pickerVC: PHPickerViewController = {
        pickerVC = PHPickerViewController(configuration: pickerConfiguration)
        pickerVC.delegate = self
        
        return pickerVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
        getFiles()
    }
    
    private func getFiles() {
        fileManagerService.getFiles {
            mainView.tableView.reloadData()
        }
    }
    
    private func configureView() {
        view = mainView
        
        configureTableView()
    }
    
    private func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        mainView.configureTableView()
    }
    
    private func configureNavBar() {
        title = "File Manager"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker))
    }
    
    @objc private func showImagePicker() {
        present(pickerVC, animated: true)
    }
    
    private func handleError(_ error: Error) {
        let vc = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        
        vc.addAction(action)
        
        present(vc, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let path = files[indexPath.row].path
        let splitedPath = files[indexPath.row].path.split(separator: "/")
        
        cell.textLabel?.text = String(splitedPath[splitedPath.count - 1])
        cell.imageView?.image = fileManagerService.getFile(by: path)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileManagerService.removeFile(by: files[indexPath.row]) {
                mainView.tableView.reloadData()
            }
        }
    }
    
}

extension MainViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                    defer {
                        group.leave()
                    }
                    
                    if let error = error {
                        self.handleError(error)
                        return
                    }

                    if let image = reading as? UIImage, let data = image.jpegData(compressionQuality: 1) {
                        self.fileManagerService.createFile(file: data)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            self.getFiles()
        }
    }
    
}
