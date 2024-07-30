//
//  PreviewVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 28/07/2024.
//
import WebKit
import UIKit

final class PreviewVC: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var preview: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
//MARK: movieData is a public variable to get and object of type Title when a cell is tapped, the cell passes the object to the view controller and the view controller passes it when instantiating a new view controller of PreviewVC, then this object passess some of it's data to the "model" variable.
    public var movieData: Title?
//MARK: after getting some of the data from movieData and apicall is made to get the videoElement, then we call configure to fill up the outlets.
    private var model: TitlePreviewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getMovie()
    }
    private func setupUI(){
        title = "Preview"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    private func configure() {
        movieTitle.text = model?.title
        preview.text = model?.titleOverview
        let youtubeURL = String(format: "%@%@", "https://www.youtube.com/embed/", model?.youtubeView.id.videoId ?? "")
        guard let url = URL(string: youtubeURL) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}
private extension PreviewVC {
    func getMovie(){
        APICaller.shared.getMovie(with: (movieData?.original_title ?? "") + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let self else {return }
                model = TitlePreviewModel(title: movieData?.original_title ?? movieData?.original_name ?? "", youtubeView: videoElement, titleOverview: movieData?.overview ?? "")
                DispatchQueue.main.async{[weak self] in
                    guard let self else{return }
                    configure()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
