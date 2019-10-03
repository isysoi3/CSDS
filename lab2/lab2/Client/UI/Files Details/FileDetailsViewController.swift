//
//  FileDetailsViewController.swift
//  lab2
//
//  Created by Ilya Sysoi on 10/3/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit

class FileDetailsViewController: UIViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: - properties
    var file: FileModel?
    
    class func newInstance(withFile file: FileModel) -> FileDetailsViewController {
        let vc = FileDetailsViewController(nibName: "FileDetailsViewController",
                                           bundle: nil)
        vc.file = file
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = file?.name
        textView.text = file?.text
    }


}
