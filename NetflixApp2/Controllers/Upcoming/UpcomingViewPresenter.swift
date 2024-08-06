//
//  UpcomingPresenter.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 05/08/2024.
//
//
import Foundation
protocol UpcomingViewPresenterProtocol: AnyObject {
    func getData(upComing: [Title]?)
}

class UpcomingViewPresenter {
 
    private var view: UpcomingViewPresenterProtocol?
    
    init(view: UpcomingViewPresenterProtocol?) {
        self.view = view
        
    }
    func viewDidLoad() {
        getUpcoming()
    }
}

private extension UpcomingViewPresenter {
    func getUpcoming(){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else {return}
            switch result{
            case .success(let titles):
                view?.getData(upComing: titles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
