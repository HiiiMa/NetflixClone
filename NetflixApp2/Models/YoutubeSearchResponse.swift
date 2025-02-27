//
//  YoutubeSearchResponse.swift
//  TheNitflex
//
//  Created by ibrahim alasl on 22/07/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
