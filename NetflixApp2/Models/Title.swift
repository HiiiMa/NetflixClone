//
//  Title.swift
//  TheNitflex
//
//  Created by ibrahim alasl on 22/07/2024.
//

import Foundation
//MARK: Models are the DATA
struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}

