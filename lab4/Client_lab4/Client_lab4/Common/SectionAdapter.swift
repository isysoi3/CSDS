//
//  SectionAdapterItem.swift
//  asto
//
//  Created by Ilya Sysoi on 10/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import UIKit

protocol SectionAdapter {
    var identifier: String { get }
    var count: Int { get }
    
    func createCell(forIndex index: Int) -> UITableViewCell
    func updateCell(_ cell: UITableViewCell, forIndex index: Int)
    func selected(atIndex index: Int)
}
