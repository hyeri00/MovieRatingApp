//
//  MovieCell.swift
//  Movie
//
//  Created by 혜리 on 2022/08/15.
//

import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var titleAndYear: UILabel!
    
    @IBOutlet weak var cast: UILabel!
    
    @IBOutlet weak var director: UILabel!
    
    @IBOutlet weak var rating: UILabel!
    
    @IBOutlet weak var thumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

