//
//  ViewController.swift
//  PiecesOfMe
//
//  Created by 이현욱 on 11/20/24.
//

import UIKit

import SnapKit

// MARK: - FileBrowserViewController
final class FileBrowserViewController: UIViewController {
    
    // MARK: - Properties
    private var isFirstScreen: Bool = true
    private var folder: FolderEntity
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        //        /button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        //        button.backgroundColor = UIColor(red: 138/255, green: 176/255, blue: 167/255, alpha: 1)
        button.addTarget(self, action: #selector(openAddItemView), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    init(folder: FolderEntity) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(folder: FolderEntity?) {
        if let folder = folder {
            self.init(folder: folder)
        } else {
            print("이러면 안됨")
            self.init(folder: FolderEntity.emptyFolder)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
//        ASD()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = folder.name
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func ASD() {
        if !isFirstScreen {
            folder = PersistenceController.shared.fetch()
            tableView.reloadData()
        }
        isFirstScreen = false
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FileBrowserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.subFolders.count + folder.preferences.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let isFolder = indexPath.row < folder.subFolders.count
        
        if isFolder {
            let folder = folder.subFolders[indexPath.row]
            cell.textLabel?.text = "📁 \(folder.name)"
        } else {
            let itemIndex = indexPath.row - folder.subFolders.count
            let item = folder.preferences[itemIndex]
            cell.textLabel?.text = "📄 \(item.name)"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < folder.subFolders.count {
            let selectedFolder = folder.subFolders[indexPath.row]
            let nextVC = FileBrowserViewController(folder: selectedFolder)
            nextVC.navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let itemIndex = indexPath.row - folder.subFolders.count
            let selectedItem = folder.preferences[itemIndex]
            print("Selected item: \(selectedItem.name)")
        }
    }
}

extension FileBrowserViewController {
    // MARK: - Actions
    @objc private func openAddItemView() {
        let addItemVC = AddItemViewController(parentFolder: folder)
        navigationController?.pushViewController(addItemVC, animated: true)
    }
}
