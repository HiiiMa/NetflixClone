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
    func getTrendingMovies(titles: [Title])
    func getTrendingTv(titles: [Title])
    func getPopular(titles: [Title])
    func getUpComming(titles: [Title])
    func getTopRated(titles: [Title])
    func setupHeaderView(headerViewImage: String?)
}

class HomeViewPresenter {
    //MARK: Variables for API Data:
    private var view: HomeViewPresenterProtocol?
    private let dispatchGroup = DispatchGroup()
    private var headerViewImage: String?
    
   
    
    init(view: HomeViewPresenterProtocol?) {
        self.view = view

    }
    
    func viewDidLoad(){
        getData()
    }
    
    private func getData() {
        dispatchGroup.enter()
        getTrendingMovies { titles in
            self.view?.getTrendingMovies(titles: titles)
            self.headerViewImage = titles.first?.poster_path ?? ""
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTrendingTv { titles in
            self.view?.getTrendingTv(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getPopular { titles in
            self.view?.getPopular(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getUpComming { titles in
            self.view?.getUpComming(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        getTopRated { titles in
            self.view?.getTopRated(titles: titles )
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else {return }
            self.view?.setupHeaderView(headerViewImage: headerViewImage)
        }
    }
    
    private func getTrendingMovies(completion: @escaping ([Title]) -> Void) {
        APICaller.shared.getTrendingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    private func getTrendingTv(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getTrendingTvs { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    private func getPopular(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getPopular { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    private func getUpComming(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    private func getTopRated(completion: @escaping ([Title]) -> Void){
        APICaller.shared.getTopRated { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                completion(titles)
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        }
    }
}
