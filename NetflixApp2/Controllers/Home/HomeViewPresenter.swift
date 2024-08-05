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

protocol HomeViewPresenterProtocol {
    func getData()
    func getTrendingMovies(completion: @escaping ()-> Void)
    func getTrendingTv(completion: @escaping ()-> Void)
    func getPopular(completion: @escaping ()-> Void)
    func getUpComming(completion: @escaping ()-> Void)
    func getTopRated(completion: @escaping ()-> Void)
}

class HomeViewPresenter: HomeViewPresenterProtocol{
    //MARK: Variables for API Data:
    let semaphore = DispatchSemaphore(value: 0)
    let dispatchGroup = DispatchGroup()
    var trendingMovies: [Title]?
    var trendingTv: [Title]?
    var popular: [Title]?
    var upComming: [Title]?
    var topRated: [Title]?
    var randomMovie: String?
    var headerViewImage: String?
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    func getData(){
        dispatchGroup.enter()
        getTrendingMovies { [weak self] in
            guard let self else { return }
            headerViewImage = trendingMovies?.first?.poster_path ?? ""
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTrendingTv { [weak self ] in
            guard let self else {return }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getPopular { [weak self] in
            guard let self else {return }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getUpComming { [weak self] in
            guard let self else {return }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTopRated { [weak self] in
            guard let self else {return }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard self != nil else {return }
            
        }
    }
    
    func getTrendingMovies(completion: @escaping ()-> Void){
        APICaller.shared.getTrendingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingMovies = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getTrendingTv(completion: @escaping ()-> Void){
        APICaller.shared.getTrendingTvs { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingTv = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getPopular(completion: @escaping ()-> Void){
        APICaller.shared.getPopular { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                popular = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getUpComming(completion: @escaping ()-> Void){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                upComming = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    func getTopRated(completion: @escaping ()-> Void){
        APICaller.shared.getTopRated { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                topRated = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
}
