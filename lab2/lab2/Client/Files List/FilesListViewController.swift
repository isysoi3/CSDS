//
//  FilesListViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

class FilesListViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    private var filesSection: GenericSectionAdapter<String, StringCell>!
    private var tableViewAdapter: TableAdapter!
    
    var files: [String] = ["sas"] {
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
        
        filesSection = GenericSectionAdapter<String, StringCell>(items: files,
                                                                 identifier: "StringCell")
        tableViewAdapter = TableAdapter(section: filesSection)
        tableView.setAdapter(tableViewAdapter)
        tableView.reloadData()
    }

}

class StringCell: UITableViewCell, Adaptable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateWithModel(_ model: String) {
        textLabel?.text = model
    }
    
}
