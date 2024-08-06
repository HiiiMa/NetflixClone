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

protocol HomeViewPresenterProtocol {
    func getData()
    var headerViewImage: String? { get  }
    var trendingMovies: [Title]? { get  }
    var trendingTv: [Title]? { get  }
    var popular: [Title]? { get  }
    var upComming: [Title]? { get  }
    var topRated: [Title]? { get  }
}

class HomeViewPresenter: HomeViewPresenterProtocol{
    //MARK: Variables for API Data:
    private weak var view: HomeViewProtocol?
    private let dispatchGroup = DispatchGroup()
    var trendingMovies: [Title]?
    var trendingTv: [Title]?
    var popular: [Title]?
    var upComming: [Title]?
    var topRated: [Title]?
    var randomMovie: String?
    var headerViewImage: String?
   
    
    init(view: HomeViewProtocol?) {
        self.view = view

    }
    
    func getData() {
        dispatchGroup.enter()
        getTrendingMovies { movies in
            self.trendingMovies = movies
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTrendingTv { movies in
            self.trendingTv = movies
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getPopular { movies in
            self.popular = movies
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getUpComming { movies in
            self.upComming = movies
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTopRated { movies in
            self.topRated = movies
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else {return }
            headerViewImage = trendingMovies?.first?.poster_path ?? ""
            self.view?.setupHeaderView()
        }
    }
    
    func getTrendingMovies(completion: @escaping ([Title]) -> Void) {
        APICaller.shared.getTrendingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingMovies = titles
                completion(trendingMovies ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func getTrendingTv(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getTrendingTvs { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingTv = titles
                completion(trendingTv ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func getPopular(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getPopular { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                popular = titles
                completion(popular ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    func getUpComming(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                upComming = titles
                completion(upComming ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    func getTopRated(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getTopRated { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                topRated = titles
                completion(topRated ?? [])
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}
