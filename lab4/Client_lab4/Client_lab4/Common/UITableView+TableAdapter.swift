//
//  UITableView+TableViewAdapter.swift
//  asto
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setAdapter(_ adapter: TableAdapter) {
        dataSource = adapter
        delegate = adapter
    }
    
}
