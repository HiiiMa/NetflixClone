//
//  PreviewViewPresenter.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 06/08/2024.
//

import SwiftLoader
import Foundation
protocol previewPassingProtocol: AnyObject {
    func getTitle(title: Title)
}
protocol previewViewPresenterProtocol: AnyObject {
    func configure(model: TitlePreviewModel?)
}
class PreviewViewPresenter {
    private weak var view: previewViewPresenterProtocol?
    //MARK: movieData is a public variable to get and object of type Title when a cell is tapped, the cell passes the object to the view controller and the view controller passes it when instantiating a new view controller of PreviewVC, then this object passess some of it's data to the "model" variable.
    private let title: Title
    //MARK: after getting some of the data from movieData and apicall is made to get the videoElement, then we call configure to fill up the outlets.
    private var model: TitlePreviewModel?
    
    init(view: previewViewPresenterProtocol? = nil, model: Title) {
        self.view = view
        self.title = model
    }
    func viewDidLoad(){
        getMovie()
    }
    
    private func getMovie(){
        SwiftLoader.show(animated: true)
        APICaller.shared.getMovie(with: (title.original_title ?? title.original_name ?? "" ) + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let self else {return }
                model = TitlePreviewModel(title: title.original_title ?? title.original_name ?? "", youtubeView: videoElement, titleOverview: title.overview ?? "")
                DispatchQueue.main.async{[weak self] in
                    guard let self else{return }
                    view?.configure(model: model)
                    SwiftLoader.hide()
                }
            case .failure(let error):
                DispatchQueue.main.async{[weak self] in
                    guard self != nil else{return }
                    //self?.delay(seconds: 0.7) { () -> () in
                        SwiftLoader.hide()
                    //}
                }
                print(error.localizedDescription)
            }
            
        }
    }
}
