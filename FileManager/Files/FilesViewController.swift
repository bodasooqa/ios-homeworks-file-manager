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
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    private lazy var fileManagerService = FileManagerService()
    
    private var files: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
        getFiles()
    }
    
    private func getFiles() {
        if let files = fileManagerService.getFiles() {
            self.files = files
            tableView.reloadData()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .white
        
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        title = "File Manager"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showImagePicker))
    }
    
}

extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let path = files[indexPath.row].path
        let splitedPath = files[indexPath.row].path.split(separator: "/")
        
        cell.textLabel?.text = String(splitedPath[splitedPath.count - 1])
        cell.imageView?.image = fileManagerService.getFile(by: path)

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
