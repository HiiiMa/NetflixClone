//
//  Router.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 01/09/2024.
//

import Foundation

struct Constantss {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}

enum APIErrorr: Error {
    case invalidURL(String)
    case requestFailed(statusCode: Int)
    case invalidResponse
    case dataConversionFailure
    case networkError
}

protocol URLRequestConvertible {
    func makeURLRequest() throws -> URL
}

enum EventRouter: URLRequestConvertible {
    case trendingMovies
    case trendingTvs
    case upcomingMovies
    case popular
    case topRated
    case discoverMovies
    case search
    case movie(query: String)
    
    var endpoint: String {
        switch self {
        case .trendingMovies:
            return "/3/trending/movie/day?api_key="
        case .trendingTvs:
            return "/3/trending/tv/day?api_key="
        case .upcomingMovies:
            return "/3/movie/upcoming?api_key="
        case .popular:
            return "/3/movie/popular?api_key="
        case .topRated:
            return "/3/movie/top_rated?api_key="
        case .discoverMovies:
            return "/3/discover/movie?api_key="
        case .search:
            return "/3/search/movie?api_key="
        case .movie(let query):
            return "q=\(query)&key="
        }
    }
    
    func makeURLRequest() throws -> URL {
        guard let url = URL(string: Constantss.baseURL + endpoint + Constantss.API_KEY) else {
            throw APIErrorr.invalidURL("Invalid URL")
        }
        return url
    }
}
