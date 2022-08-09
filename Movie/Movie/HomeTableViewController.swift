//
//  HomeTableViewController.swift
//  Movie
//
//  Created by 혜리 on 2022/08/09.
//

import UIKit

class HomeTableViewController: UITableViewController {
        
    var dataset = [
        ("다크나이트", "홍길동", "2013", 4.5, "Dark Knight.jpeg")] // 테스트용
    
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        for(title, cast, year, rating, thumbnail) in self.dataset {
            let mvo = MovieVO()
            mvo.title = title
            mvo.cast = cast
            mvo.year = year
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            
            datalist.append(mvo)
        }
        return datalist
    }()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    // 각 행에 대한 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        // 데이터 소스에 저장된 값을 각 아울렛 변수에 할당
        cell.title?.text = row.title
        cell.cast?.text = row.cast
        cell.year?.text = row.year
        cell.rating?.text = "\(row.rating)"
        cell.thumbnail?.image = UIImage(named: row.thumbnail!)
        
        return cell
    }
    
}
