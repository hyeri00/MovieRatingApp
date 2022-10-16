//
//  MyListViewController.swift
//  Movie
//
//  Created by 혜리 on 2022/08/10.
//

import UIKit



class MyListViewController: UIViewController {

    
    @IBOutlet weak var listTitle: UILabel!
    var data: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = data {
            listTitle.text = data
            listTitle.sizeToFit()
        }
    }
}


