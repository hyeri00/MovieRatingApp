//
//  HomeTableViewController.swift
//  Movie
//
//  Created by 혜리 on 2022/08/09.
//

import UIKit
import Alamofire
import SafariServices
import RealmSwift



class HomeTableViewController: UITableViewController {
    
    // Outlet 연결
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet var homeTableView: UITableView!
    @IBAction func bookMarkButton(_ sender: UIButton) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let viewController = segue.destination as? MyListViewController {
                viewController.data = " "
                
            }
        }
    }
    
    
    // API
    let clientID = "QLUdlxBD0Ccvy2oE57eZ"
    let clientSecret = "ZJaZWveLGB"
    
    
    let posterImageQueue = DispatchQueue(label: "posterImage")
    var queryText: String?
    var movies: [Movie] = [] // API를 통해 받아온 결과를 저장할 Array
    var item: Movie? = nil
    let realm = try? Realm()
    var movieData : MovieData?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchBar()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) // Realm 저장 위치
    }
    
    // 데이터 저장
    func saveData() {
        if movieData == nil {
            
        }
    }
    
    // 데이터 Realm에 추가
    func addMovieData() {
        movieData = MovieData()
//        movieData = inputDataToMovieData(db: movieData!)
        
        try? realm?.write {
            realm?.add((movieData)!)
        }
    }
    
    // MovieData 업데이트
    func updateMovieData() {
        try? realm?.write {
//            movieData = inputDataToMovieData(db: movieData!)
        }
    }
    
    // MovieData에 데이터를 저장하고, Realm에 저장
//    func inputDataToMovieData(db: MovieData) -> MovieData {
//
//    }
    
    
    func setSearchBar() {
        searchText.placeholder = "검색어를 입력하세요"
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func searchMovies() {
        movies = []
        
        print("queryText: \(String(describing: queryText))")
        
        guard let query = queryText else {
            return
        }
        
        let urlString = "https://openapi.naver.com/v1/search/movie.json?query=" + query
        let urlWithPercentEscapes = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: urlWithPercentEscapes!)
        
        var request = Alamofire.URLRequest(url: url!)
        request.addValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error as Any)
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            print("data \(data)")
            
            
            DispatchQueue.main.sync {
                do {
                    // 지금 요거가 JSONSerialization을 사용한 파싱이다.
                    // data byte 정보를 파싱할 수 있는 원본 데이터 형태로 만든 것
                    let object = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    // Optional 이여서 빼냄
                    guard let jsonObject = object else { return }
                    
                    
                    // 1뎁스 긁어옴. 트리구조 설명 기억해
                    let lastBuildDate = jsonObject["lastBuildDate"]
                    let total = jsonObject["total"]
                    let start = jsonObject["start"]
                    let display = jsonObject["display"]
                    let items: NSArray = jsonObject["items"] as! NSArray
                    
                    print("\(lastBuildDate)")
                    print("\(total)")
                    print("\(start)")
                    print("\(display)")
                    print("\(items)")
                    
                    
                    // 1뎁스의 items for문돌려서 movies에 하나하나 넣어줌.
                    items.forEach { item in
                        let item = item as! NSDictionary
                        
                        // 2뎁스인 items 안의 item 데이터 파싱함.
                        let title = item["title"] as! String
                        let link = item["link"] as! String
                        let image = item["image"] as! String
                        let subtitle = item["subtitle"] as! String
                        let pubDate = item["pubDate"] as! String
                        let director = item["director"] as! String
                        let actor = item["actor"] as! String
                        let userRating = item["userRating"] as! String
                        
                        print("\(title)")
                        print("\(link)")
                        print("\(image)")
                        print("\(subtitle)")
                        print("\(pubDate)")
                        print("\(director)")
                        print("\(actor)")
                        print("\(userRating)")
                        
                        
                        // Movie 라는 객체를 생성했어
                        let movie = Movie (
                            // Movie 안의 내용을 채워줘
                            title: title,
                            link: link,
                            imageURL: image,
                            pubDate: pubDate,
                            director: director,
                            actors: actor,
                            userRating: userRating
                            
                        )
                        
                        // movies array에 추가해줘
                        self.movies.append(movie)
                    }
                    
                    self.movies.forEach { movie in
                        //                        print("Movie Item : \(movie)")
                    }
                    
                    // 데이터 준비됐으니까 다시그려
                    self.homeTableView.reloadData()
                } catch let e {
                    print("에러에러에러 : \(e.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    
    
    // MARK: - Table view data source
    
    // 클릭 가능 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    // 셀 정보
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        
        guard let title = movie.title, let pubDate = movie.pubDate, let userRating = movie.userRating, let director = movie.director, let actor = movie.actors else {
            return cell
        }
        
        cell.titleAndYear.text = "\(title) (\(pubDate))"
        cell.titleAndYear.text = title
            .replacingOccurrences(of: "</b>", with: "")
            .replacingOccurrences(of: "<b>", with: "")
        
        if director == "" {
            cell.director.text = "정보 없음"
        } else {
            cell.director.text = "\(director)"
            if item?.director != "" {
                item?.director?.removeLast()
            }
        }
        
        if actor == "" {
            cell.cast.text = "정보 없음"
        } else {
            cell.cast.text = "\(actor)"
            if item?.actors != "" {
                item?.actors?.removeLast()
            }
        }
        
        if userRating == "0.00" {
            cell.rating.text = "정보 없음"
        } else {
            cell.rating.text = "\(userRating)"
        }
        
        if let posterImage = movie.image {
            cell.thumbnail.image = posterImage
        } else {
            cell.thumbnail.image = UIImage(named: "noImage")
            posterImageQueue.async(execute: {
                movie.getThumbnailImage()
                guard let thumbImage = movie.image else {
                    return
                }
                
                DispatchQueue.main.async {
                    cell.thumbnail.image = thumbImage
                }
            })
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = movies[indexPath.row].link {
            if let url = URL(string: urlString) {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row >= 0) {
            return 120
        }
        return UITableView.automaticDimension
    }
}


extension HomeTableViewController: UISearchBarDelegate {
    
    private func dismissKeyboard() {
        searchText.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.homeTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        DispatchQueue.main.async {
            self.homeTableView.reloadData()
        }
        
        if let text = searchText.text {
            queryText = text
            // 검색 시도
            searchMovies()
            print("\(text)")
        }
    }
}
