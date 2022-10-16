//
//  MovieData.swift
//  Movie
//
//  Created by 혜리 on 2022/10/14.
//

import Foundation
import RealmSwift

class MovieData: Object {
    @objc dynamic var titleAndYearData = ""
    @objc dynamic var thumbnailData = ""
    @objc dynamic var titleData = ""
    @objc dynamic var directorData = ""
    @objc dynamic var actorData = ""
    @objc dynamic var ratingData = ""
}

/* @objc dynamic을 붙이는 이유는
 기본 데이터베이스 데이터에 대한 속성 접근자를 만들기 위해서다.
 그래야 데이터에 대해 접근이 가능해서 변경사항을 업데이트 할 수 있다. */

