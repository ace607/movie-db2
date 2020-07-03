//
//  Movie.swift
//  movie-db2
//
//  Created by katia kutsi on 7/3/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let poster: String
    let title: String
    let genreIDS: [Int]
    let imdb: Double
    let overview: String

    enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case title = "original_title"
        case genreIDS = "genre_ids"
        case imdb = "vote_average"
        case overview
    }
}

struct MoviesResponse: Codable {
    let movies : [Movie]
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}
