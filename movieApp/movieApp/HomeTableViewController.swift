//
//  HomeTableViewController.swift
//  movieApp
//
//  Created by 혜리 on 2022/08/15.
//

import UIKit
import SafariServices
import Alamofire

class HomeTableViewController: UITableViewController, XMLParserDelegate {
    
    /* Outlet 연결 */
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet var homeTableView: UITableView!
    @IBAction func bookMarkButton(_ sender: Any) {
    
    }
    
//    @IBAction func checkButton(_ sender: Any) {
//        if let text = searchText.text {
//            queryText = text
//            // 검색 시도
//            searchMovies()
//            print("\(text)")
//        }
//    }
    
    let posterImageQueue = DispatchQueue(label: "posterImage")
    
    let clientID = "fcbFnRUuFjSoK9wIVLUY"
    let clientSecret = "g4RLpNpuBN"
    
    var queryText: String? = ""
    var movies : [Movie] = []
    
    var currentTag: String? = ""
    var currentElement: String = ""
    var item: Movie? = nil

    override func viewDidLoad() {
        // 처음 검색 화면 로드될때 1회 호출
        setSearchBar()
    }
    
    func setSearchBar() {
        searchText.placeholder = " 검색어를 입력하세요."
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
    
    
    
    // MARK: Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        guard let title = movie.title, let pubDate = movie.pubDate, let userRating = movie.userRating, let director = movie.director, let actor = movie.actors else {
            return cell
        }
        
        
        cell.titleAndYear.text = "\(title) (\(pubDate))"
        
//        if title == "\(title)(\(pubDate))" {
//            cell.titleAndYear.text = "\(title)(\(pubDate))"
//            if item?.title != "" {
//                currentElement.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//            }
//        }
        
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
