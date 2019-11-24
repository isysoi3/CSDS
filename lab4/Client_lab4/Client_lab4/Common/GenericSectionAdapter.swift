//
//  GenericSectionAdapterItem.swift
//  asto
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import UIKit

protocol Adaptable {
    associatedtype Model
    
    func updateWithModel(_ model: Model)
}

class GenericSectionAdapter<Model, Cell>: SectionAdapter
where Cell: UITableViewCell, Cell: Adaptable, Cell.Model == Model {
    
    // MARK: - properties
    var items: [Model]
    var onSelected: ((Model) -> ())? = nil
    
    
    // MARK: - init
    init(items: [Model] = [], identifier: String) {
        self.items = items
        self.identifier = identifier
    }
    
    
    // MARK: - SectionAdapterItem implementation
    var identifier: String
    var count: Int {
        return items.count
    }
    
    func createCell(forIndex index: Int) -> UITableViewCell {
        let c = Cell()
        c.updateWithModel(items[index])
        return c
    }
    
    func updateCell(_ cell: UITableViewCell, forIndex index: Int) {
        if let cell = cell as? Cell {
            cell.updateWithModel(items[index])
        }
    }
    
    func selected(atIndex index: Int) {
        onSelected?(items[index])
    }
    
}
