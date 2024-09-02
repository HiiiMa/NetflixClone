//
//  NetwrokRepository.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 01/09/2024.
//

import Foundation

protocol NetworkRepositoryProtocol {
    func fetchMovies(route: EventRouter) async  -> [Title]
}

class NetworkRepository: NetworkRepositoryProtocol {
    let networkService: NetworkServiceProtocol
    var movies: [Title] = []
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovies(route: EventRouter) async  -> [Title] {
        let titles =  await networkService.fetchMovies(route: route)
        return titles
    }
}
