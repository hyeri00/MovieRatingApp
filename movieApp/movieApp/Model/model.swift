//
//  model.swift
//  movieApp
//
//  Created by 혜리 on 2022/08/15.
//

import Foundation
import UIKit

class Movie {
    var title: String?
    var link: String?
    var imageURL: String?
    var image: UIImage?
    var pubDate: String?
    var director: String?
    var actors: String?
    var userRating: String?
    
    init(title: String, link: String, imageURL: String, pubDate: String, director: String, actors: String, userRating: String) {
        self.title = title
        self.link = link
        self.imageURL = imageURL
        self.pubDate = pubDate
        self.director = director
        self.actors = actors
        self.userRating = userRating
    }
    
    
    func getThumbnailImage() {
        guard imageURL != nil else {
            return
        }
        if let url = URL(string: imageURL!) {
            if let imgData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imgData) {
                    self.image = image
                }
            }
        }
        return
    }
    
   
    
//    func getDescription() {
//        title: String, link: String, imageURL: String, pubDate: String, director: String, actors: String, userRating: String
//
//    }
}
