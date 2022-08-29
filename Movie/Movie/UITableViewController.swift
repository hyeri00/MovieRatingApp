//
//  UITableViewController.swift
//  Movie
//
//  Created by 혜리 on 2022/08/10.
//

import UIKit

extension UITableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PersonCell
        
        cell.name.text = row.name
        cell.age.text = row.age
    }
    
    
}
