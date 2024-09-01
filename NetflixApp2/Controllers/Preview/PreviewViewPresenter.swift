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
    func showLoadingView()
    func hideLoadingView()
}
class PreviewViewPresenter {
    private weak var view: previewViewPresenterProtocol?
    private let title: Title
    private var model: TitlePreviewModel?
//MARK: - This init performs Init dependancy injection: passing the "service/data" the view depends on.
    init(view: previewViewPresenterProtocol? = nil, model: Title) {
        self.view = view
        self.title = model
    }
    func viewDidLoad(){
        getMovie()
    }
    private func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    private func getMovie(){
       // SwiftLoader.show(animated: true)
        view?.showLoadingView()
        APICaller.shared.getMovie(with: (title.original_title ?? title.original_name ?? "" ) + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let self else {return }
                model = TitlePreviewModel(title: title.original_title ?? title.original_name ?? "", youtubeView: videoElement, titleOverview: title.overview ?? "")
                DispatchQueue.main.async{[weak self] in
                    guard let self else{return }
                    view?.configure(model: model)
                    view?.hideLoadingView()
                   // SwiftLoader.hide()
                }
            case .failure(let error):
                DispatchQueue.main.async{ [weak self] in
                    guard self != nil else{return }
                    self?.delay(seconds: 0.7) { () -> () in
                        //SwiftLoader.hide()
                    }
                }
                print(error.localizedDescription)
            }
            
        }
    }
}
