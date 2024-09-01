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
        view?.showLoadingView()
        getTrendingMovies { [weak self] titles in
            self?.view?.getTrendingMovies(titles: titles)
            self?.headerViewImage = titles.first?.poster_path ?? ""
            self?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        view?.showLoadingView()
        getTrendingTv { titles in
            self.view?.getTrendingTv(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        view?.showLoadingView()
        getPopular { titles in
            self.view?.getPopular(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        view?.showLoadingView()
        getUpComming { titles in
            self.view?.getUpComming(titles: titles)
            self.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        view?.showLoadingView()
        getTopRated { titles in
            self.view?.getTopRated(titles: titles )
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else {return }
            self.view?.setupHeaderView(headerViewImage: headerViewImage)
            self.view?.hideLoadingView()
        }
    }
    
    private func getTrendingMovies(completion: @escaping ([Title]) -> Void) {
        APICaller.shared.getTrendingMovies { result in
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
        APICaller.shared.getTrendingTvs {  result in
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
        APICaller.shared.getPopular { result in
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
        APICaller.shared.getUpcomingMovies { result in
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
        APICaller.shared.getTopRated { result in
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
