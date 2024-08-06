//
//  SearchViewPresenter.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 06/08/2024.
//

import Foundation
protocol searchViewPresenterProtocol: AnyObject {
    func getData(titles: [Title])
}

class SearchViewPresenter {
    
    private weak var view: searchViewPresenterProtocol?
    
    init(view: searchViewPresenterProtocol?) {
        self.view = view
    }
    
    func viewDidLoad(){
        getDiscover()
    }
    func getDiscover(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            guard let self else {return}
            switch result{
            case .success(let titles):
                view?.getData(titles: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
