//
//  Comment.swift
//  BoxOffice
//
//  Created by 공지원 on 12/12/2018.
//  Copyright © 2018 공지원. All rights reserved.
//

/*
 {
 rating: 10,
 timestamp: 1515748870.80631,
 writer: "두근반 세근반",
 movie_id: "5a54c286e8a71d136fb5378e",
 contents:"정말 다섯 번은 넘게 운듯 ᅲᅲᅲ 감동 쩔어요.꼭 보셈 두 번 보셈"
 }
 */

import Foundation

struct CommentApiResponse: Codable {
    let comments : [Comment]?
    let movieId : String?
    
    enum CodingKeys: String, CodingKey {
        case comments
        case movieId = "movie_id"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comments = try values.decodeIfPresent([Comment].self, forKey: .comments)
        movieId = try values.decodeIfPresent(String.self, forKey: .movieId)
    }
}

struct Comment: Codable {
    let contents : String?
    let id : String?
    let movieId : String?
    let rating : Double?
    let timestamp : Double?
    let writer : String?
    
    enum CodingKeys: String, CodingKey {
        case contents
        case id
        case movieId = "movie_id"
        case rating
        case timestamp
        case writer
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        contents = try values.decodeIfPresent(String.self, forKey: .contents)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        movieId = try values.decodeIfPresent(String.self, forKey: .movieId)
        rating = try values.decodeIfPresent(Double.self, forKey: .rating)
        timestamp = try values.decodeIfPresent(Double.self, forKey: .timestamp)
        writer = try values.decodeIfPresent(String.self, forKey: .writer)
    }
}
