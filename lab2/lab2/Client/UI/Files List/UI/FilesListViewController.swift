//
//  FilesListViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit
import Combine

class FilesListViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    private var activityIndicator: UIActivityIndicatorView?
    
    private var filesSection: GenericSectionAdapter<FileModel, StringCell>!
    private var tableViewAdapter: TableAdapter!
    
    private var viewModel = FilesListViewModel()
    
    var files: [FileModel] = [FileModel(name: "test")] {
        didSet {
            filesSection.items = files
            tableView.reloadData()
        }
    }
    
    class func newInstance() -> FilesListViewController {
        return FilesListViewController(nibName: "FilesListViewController",
                                       bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initVM()
        viewModel.getFiles()
    }
    
    func initUI() {
        filesSection = GenericSectionAdapter<FileModel, StringCell>(items: files,
                                                                    identifier: "StringCell")
        filesSection.onSelected = { [weak self] file in
            self?.viewModel.getFile(name: file.name)
        }
        tableViewAdapter = TableAdapter(section: filesSection)
        tableView.setAdapter(tableViewAdapter)
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: viewModel,
            action: #selector(viewModel.getFiles))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "key"),
            style: .plain,
            target: viewModel,
            action: #selector(viewModel.generateKeys))
        
        title = "RSA Notes"
    }
    
    func initVM() {
        _  = viewModel.$files
            .receive(on: DispatchQueue.main)
            .assign(to: \.files, on: self)
        
        _  = viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                if let error = error {
                    let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Хорошо", style: .default))
                    self?.present(alert, animated: true)
                }
            })
        
        _  = viewModel.$selectedFile
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] selectedFile in
                if let file = selectedFile {
                    let vc = FileDetailsViewController.newInstance(withFile: file)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        
        _  = viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard let `self` = self else { return }
                if isLoading {
                    self.activityIndicator = UIActivityIndicatorView(style: .medium)
                    self.activityIndicator!.frame = CGRect(x: self.view.center.x - 23,
                                                           y: self.view.center.y - 123,
                                                           width: 46,
                                                           height: 46)
                    self.activityIndicator!.startAnimating()
                    self.tableView.addSubview(self.activityIndicator!)
                } else {
                    self.activityIndicator?.stopAnimating()
                    self.activityIndicator?.removeFromSuperview()
                }
            })
        
        _  = viewModel.$message
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] message in
                if let message = message {
                    self?.showAlert(title: "Ошибка", message: message)
                }
            })
    }
    
}

class StringCell: UITableViewCell, Adaptable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        accessoryType = .disclosureIndicator
    }
    
    func updateWithModel(_ model: FileModel) {
        textLabel?.text = model.name
    }
    
}
