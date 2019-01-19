//
//  MovieDetail.swift
//  BoxOffice
//
//  Created by 공지원 on 12/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

/*
 {
 audience: 11676822,
 grade: 12,
 actor: "하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)",
 duration: 139,
 reservation_grade: 1,
 title: "신과함께-죄와벌",
 reservation_rate: 35.5,
 user_rating: 7.98,
 date: "2017-12-20",
 director: "김용화",
 id: "5a54c286e8a71d136fb5378e",
 image: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg",
 synopsis: "저승 법에 의하면, (중략) 고난과 맞닥뜨리는데... 누구나 가지만 아무도 본 적 없는 곳, 새로운 세계의 문이 열린다!",
 genre: "판타지, 드라마"
 }
 */

import Foundation

struct MovieDetail: Codable {
    let actor : String?
    let audience : Int?
    let date : String?
    let director : String?
    let duration : Int?
    let genre : String?
    let grade : Int?
    let id : String?
    let image : String?
    let reservationGrade : Int?
    let reservationRate : Double?
    let synopsis : String?
    let title : String?
    let userRating : Double?
    
    enum CodingKeys: String, CodingKey {
        case actor
        case audience
        case date
        case director
        case duration
        case genre
        case grade
        case id
        case image
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case synopsis
        case title
        case userRating = "user_rating"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        actor = try values.decodeIfPresent(String.self, forKey: .actor)
        audience = try values.decodeIfPresent(Int.self, forKey: .audience)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        director = try values.decodeIfPresent(String.self, forKey: .director)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        genre = try values.decodeIfPresent(String.self, forKey: .genre)
        grade = try values.decodeIfPresent(Int.self, forKey: .grade)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        reservationGrade = try values.decodeIfPresent(Int.self, forKey: .reservationGrade)
        reservationRate = try values.decodeIfPresent(Double.self, forKey: .reservationRate)
        synopsis = try values.decodeIfPresent(String.self, forKey: .synopsis)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        userRating = try values.decodeIfPresent(Double.self, forKey: .userRating)
    }
}

enum Path: String {
    case list = "/movies"
    case detail = "/movie"
    case comments = "/comments"
}

enum Components: String {
    case orderType = "?order_type="
    case movieId = "?id="
    case commentsMovieId = "?movie_id="
}
