//
//  MainViewController.swift
//  FileManager
//
//  Created by t.lolaev on 02.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var mainView = MainView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavBar()
        configureView()
    }
    
    private func configureView() {
        view = mainView
        
        configureTableView()
    }
    
    func configureTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        mainView.configureTableView()
    }
    
    private func configureNavBar() {
        title = "File Manager"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addNewPhoto))
    }
    
    @objc private func addNewPhoto() {
        print("Added")
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }
    
}
