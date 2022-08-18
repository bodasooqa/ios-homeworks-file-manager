//
//  FilesViewController.swift
//  FileManager
//
//  Created by t.lolaev on 02.06.2022.
//

import UIKit
import Photos
import PhotosUI
import FileManagerService

class FilesViewController: UIViewController {
    
    private static let cellIdentifier = "cell"
    
    private let userDefaults = UserDefaults.standard
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let fileManagerService = FileManagerService()
    
    private var files: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
        getFiles()
    }
    
    private func getFiles() {
        self.files = fileManagerService.getFiles()
        checkUserDefaults()
        tableView.reloadData()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker))
    }
    
    private func checkUserDefaults() {
        if let sortOption = userDefaults.string(forKey: "sort-option") {
            sortFiles(by: sortOption)
        }
    }
    
    public func sortFiles(by option: String) {
        files = files.sorted(by: { prev, next in
            option == "From A to Z" ? prev.description < next.description : prev.description > next.description
        })
        tableView.reloadData()
    }
    
}

// MARK: - TableView

extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier, for: indexPath)
        
        let path = files[indexPath.row].path
        let splitedPath = files[indexPath.row].path.split(separator: "/")
        
        cell.textLabel?.text = String(splitedPath[splitedPath.count - 1])
        cell.imageView?.image = fileManagerService.getImage(by: path)

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let fileUrl = files[indexPath.row]
        
        if editingStyle == .delete {
            fileManagerService.removeFile(by: fileUrl) {
                self.files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
}

// MARK: - ImagePicker

extension FilesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, let data = image.jpegData(compressionQuality: 1) {
            self.fileManagerService.createFile(file: data)
            self.getFiles()
        }
        picker.dismiss(animated: true)
    }
}
