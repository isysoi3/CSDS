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
    
    private var filesSection: GenericSectionAdapter<FileModel, StringCell>!
    private var tableViewAdapter: TableAdapter!
    
    private var filesSubscriber: AnyCancellable?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.getFiles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        initVM()
    }

    func initUI() {
        filesSection = GenericSectionAdapter<FileModel, StringCell>(items: files,
                                                                    identifier: "StringCell")
        tableViewAdapter = TableAdapter(section: filesSection)
        tableView.setAdapter(tableViewAdapter)
        tableView.reloadData()
    }
    
    func initVM() {
        filesSubscriber = viewModel.$files.receive(on: DispatchQueue.main).assign(to: \.files,
                                                                                  on: self)
    }
    
}

class StringCell: UITableViewCell, Adaptable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateWithModel(_ model: FileModel) {
        textLabel?.text = model.name
    }
    
}
