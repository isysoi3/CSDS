//
//  TableViewAdapter.swift
//  asto
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import UIKit

class TableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - properties
    var sections: [SectionAdapter]
    
    
    // MARK: - init
    convenience init(section: SectionAdapter) {
        self.init(sections: [section])
    }
    
    init(sections: [SectionAdapter]) {
        self.sections = sections
    }
    
    
    // MARK: - UITableViewDataSource and UITableViewDelegate implementation
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = sections[indexPath.section].identifier
        guard let reusableCell = tableView.dequeueReusableCell(withIdentifier: identifier) else {
            return sections[indexPath.section].createCell(forIndex: indexPath.item)
        }
        sections[indexPath.section].updateCell(reusableCell, forIndex: indexPath.item)
        return reusableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].selected(atIndex: indexPath.item)
    }
}
