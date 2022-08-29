//
//  HomeTableViewController.swift
//  Movie
//
//  Created by 혜리 on 2022/08/09.
//

import UIKit
import Alamofire

class HomeTableViewController: UITableViewController, XMLParserDelegate {
    
    let clientID = "fcbFnRUuFjSoK9wIVLUY"
    let clientSecret = "zhGjFJ1zX4"
//
//    var queryText: String?
//    var movies: [Movie] = [] // API를 통해 받아온 결과를 저장할 Array
//
//    var strXMLData: String? = ""
//    var currentTag: String? = ""
//    var currentElement: String = ""
//    var item: Movie? = nil
    
    
    
    
    
    @IBOutlet weak var searchText: UISearchBar!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
//
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return movies.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellIdentifier", for: indexPath) as! MovieCell
//        
//        return cell
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }



}
