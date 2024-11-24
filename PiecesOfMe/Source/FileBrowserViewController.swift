//
//  ViewController.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/20/24.
//

import UIKit

import SnapKit

// MARK: - Models
enum ContentType {
    case folder
    case item
}

struct Directory {
    let name: String
    var folders: [Directory]
    var items: [Item]
}

struct Item {
    let name: String
//    let image: UIImage?
//    let date: TimeInterval
}

// MARK: - FileBrowserViewController
final class FileBrowserViewController: UIViewController {
    
    // MARK: - Properties
    private var directory: Directory
    private lazy var tableView: UITableView = createTableView()
    private lazy var createButton: UIButton = createAddButton()

    // MARK: - Initializer
    init(directory: Directory) {
        self.directory = directory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = directory.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
        
        view.addSubview(tableView)
        setupTableViewConstraints()
    }

    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createAddButton() -> UIButton {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        button.addTarget(self, action: #selector(openAddItemView), for: .touchUpInside)
        return button
    }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }

    // MARK: - Actions
    @objc private func openAddItemView() {
        let addItemVC = AddItemViewController()
        navigationController?.pushViewController(addItemVC, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FileBrowserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directory.folders.count + directory.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let isFolder = indexPath.row < directory.folders.count
        
        if isFolder {
            let folder = directory.folders[indexPath.row]
            cell.textLabel?.text = "📁 \(folder.name)"
        } else {
            let itemIndex = indexPath.row - directory.folders.count
            let item = directory.items[itemIndex]
            cell.textLabel?.text = "📄 \(item.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < directory.folders.count {
            let selectedFolder = directory.folders[indexPath.row]
            let nextVC = FileBrowserViewController(directory: selectedFolder)
            nextVC.navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let itemIndex = indexPath.row - directory.folders.count
            let selectedItem = directory.items[itemIndex]
            print("Selected item: \(selectedItem.name)")
        }
    }
}
