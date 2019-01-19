//
//  Movie.swift
//  BoxOffice
//
//  Created by 공지원 on 10/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//
/*
{
    grade: 12,
    thumb: "http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2",
    reservation_grade: 1,
    title: "신과함께-죄와벌",
    reservation_rate: 35.5,
    user_rating: 7.98,
    date: "2017-12-20",
    id: "5a54c286e8a71d136fb5378e"
    }
 */

import Foundation

struct APIResponse: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    let grade: Int? //관람 등급
    let thumb: String? //썸네일 이미지 url
    let reservationGrade: Int? //예매 순위
    let title: String? //제목
    let reservationRate: Double? //예매율
    let userRating: Double? //평점
    let date: String? //개봉일
    let id: String? //영화 고유 id

    enum CodingKeys: String, CodingKey {
        case grade
        case thumb
        case reservationGrade = "reservation_grade"
        case title
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
        case date
        case id
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        grade = try values.decodeIfPresent(Int.self, forKey: .grade)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        reservationGrade = try values.decodeIfPresent(Int.self, forKey: .reservationGrade)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        reservationRate = try values.decodeIfPresent(Double.self, forKey: .reservationRate)
        userRating = try values.decodeIfPresent(Double.self, forKey: .userRating)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}

enum OrderType: String {
    case reservation = "0"
    case quration = "1"
    case date = "2"
}
