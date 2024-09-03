//
//  HomeViewPresenter.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 05/08/2024.
//

import Foundation
import UIKit

enum Sections: Int {
    case trendingMovies = 0
    case trendingTvs = 1
    case popular = 2
    case upcomingMovies = 3
    case topRated = 4
}

let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]

//MARK: - This protocol performs Interface dependancy injection: making the view conforms and getting the "service/data" it depend on.
protocol HomeViewPresenterProtocol {
    func getMovies(titles: [Title], section: Sections)
    func setupHeaderView(headerViewImage: String?)
    func showLoadingView()
    func hideLoadingView()
}

class HomeViewPresenter {
    private var view: HomeViewPresenterProtocol?
    private let networkRepository = NetworkRepository(networkService: NetworkService())
    private var headerViewImage: String?
    private var movies: [Title] = []
    
    init(view: HomeViewPresenterProtocol?) {
        self.view = view
    }
    
    func viewDidLoad(){
        getData()
    }
}
//MARK: - API:
private extension HomeViewPresenter {
    func getAllMovies() async {
        movies = await networkRepository.fetchMovies(route: .trendingMovies)
        await MainActor.run {
            view?.getMovies(titles: movies, section: .trendingMovies)
            headerViewImage = movies.first?.poster_path ?? ""
        }
        
        movies = await networkRepository.fetchMovies(route: .trendingTvs)
        await MainActor.run { view?.getMovies(titles: movies, section: .trendingTvs) }
        
        movies = await networkRepository.fetchMovies(route: .popular)
        await MainActor.run { view?.getMovies(titles: movies, section: .popular) }
        
        movies = await networkRepository.fetchMovies(route: .upcomingMovies)
        await MainActor.run { view?.getMovies(titles: movies, section: .upcomingMovies) }
        
        movies = await networkRepository.fetchMovies(route: .topRated)
        await MainActor.run {
            view?.getMovies(titles: movies, section: .topRated)
            view?.setupHeaderView(headerViewImage: headerViewImage)
        }
    }
    
    func getData() {
        Task { await getAllMovies() }
    }
}
