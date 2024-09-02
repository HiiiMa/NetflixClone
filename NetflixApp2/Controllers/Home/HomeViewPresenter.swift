//
//  HomeViewPresenter.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 05/08/2024.
//

import Foundation
import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
//MARK: - This protocol performs Interface dependancy injection: making the view conforms and getting the "service/data" it depend on.
protocol HomeViewPresenterProtocol {
    func getTrendingMovies(titles: [Title])
    func getTrendingTv(titles: [Title])
    func getPopular(titles: [Title])
    func getUpComming(titles: [Title])
    func getTopRated(titles: [Title])
    func setupHeaderView(headerViewImage: String?)
    func showLoadingView()
    func hideLoadingView()
}

class HomeViewPresenter {
    //MARK: Variables for API Data:
    private var view: HomeViewPresenterProtocol?
    private let networkRepository = NetworkRepository(networkService: NetworkService())
    private let dispatchGroup = DispatchGroup()
    private let dispatchQueue = DispatchQueue(label: "movies", qos: .userInitiated)
    private var headerViewImage: String?
    private var trendingMovies: [Title] = []
    private var trendingTv: [Title] = []
    private var popular: [Title] = []
    private var upComming: [Title] = []
    private var topRated: [Title] = []
    
    init(view: HomeViewPresenterProtocol?) {
        self.view = view
    }
    
    func viewDidLoad(){
        getData()
    }
    
    func getAllMovies() async {
        trendingMovies = await networkRepository.fetchMovies(route: .trendingMovies)
        trendingTv = await networkRepository.fetchMovies(route: .trendingTvs)
        popular = await networkRepository.fetchMovies(route: .popular)
        upComming = await networkRepository.fetchMovies(route: .upcomingMovies)
        topRated = await networkRepository.fetchMovies(route: .topRated)
    }
    
    private func getData() {
        Task {
            await getAllMovies()
            await MainActor.run {
                view?.getTrendingMovies(titles: trendingMovies)
                headerViewImage = trendingMovies.first?.poster_path ?? ""
                view?.getTrendingTv(titles: trendingTv)
                view?.getPopular(titles: popular)
                view?.getUpComming(titles: upComming)
                view?.getTopRated(titles: topRated)
                view?.setupHeaderView(headerViewImage: headerViewImage)
            }
        }
    }
}
