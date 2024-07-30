//
//  PreviewVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 28/07/2024.
//
import WebKit
import UIKit
import SwiftLoader

final class PreviewVC: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var preview: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    //MARK: movieData is a public variable to get and object of type Title when a cell is tapped, the cell passes the object to the view controller and the view controller passes it when instantiating a new view controller of PreviewVC, then this object passess some of it's data to the "model" variable.
    public var movieData: Title?
    //MARK: after getting some of the data from movieData and apicall is made to get the videoElement, then we call configure to fill up the outlets.
    private var model: TitlePreviewModel?
    //var spinner: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // spinner = UIActivityIndicatorView(frame: view.frame)
        showSwiftLoader()
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
        //showLoader()
        SwiftLoader.show(animated: true)
        APICaller.shared.getMovie(with: (movieData?.original_title ?? "") + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                guard let self else {return }
                model = TitlePreviewModel(title: movieData?.original_title ?? movieData?.original_name ?? "", youtubeView: videoElement, titleOverview: movieData?.overview ?? "")
                DispatchQueue.main.async{[weak self] in
                    guard let self else{return }
                    configure()
                    SwiftLoader.hide()
                    // hideLoader()
                }
            case .failure(let error):
                DispatchQueue.main.async{[weak self] in
                    guard self != nil else{return }
                    self?.delay(seconds: 0.7) { () -> () in
                        SwiftLoader.hide()
                    }
                    //hideLoader()
                }
                print(error.localizedDescription)
            }
            
        }
    }
}
extension PreviewVC{
    func delay(seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
    }
    @objc func showSwiftLoader() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        config.backgroundColor = .black
        config.spinnerColor = .white
        config.titleTextColor = .white
        config.spinnerLineWidth = 2.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.5
        
        SwiftLoader.setConfig(config)
    }
}
//extension PreviewVC {
//    func showLoader()  {
//        // Customize as per your need
//        guard let spinner else { return }
//        spinner.backgroundColor = UIColor.black.withAlphaComponent(1)
//        spinner.layer.cornerRadius = 3.0
//        spinner.clipsToBounds = true
//        spinner.hidesWhenStopped = true
//        spinner.style = .medium // Corrected this line
//        spinner.center = view.center
//        view.addSubview(spinner)
//        spinner.startAnimating()
//        view.isUserInteractionEnabled = false // Disable interaction
//    }
//
//    func hideLoader() {
//        guard let spinner else { return }
//        spinner.stopAnimating()
//        spinner.removeFromSuperview()
//        view.isUserInteractionEnabled = true // Re-enable interaction
//    }
//}
//
