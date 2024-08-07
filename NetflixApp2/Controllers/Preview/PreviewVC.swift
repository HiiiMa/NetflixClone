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
    
    var presenter: PreviewViewPresenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        showSwiftLoader()
        presenter?.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        title = "Preview"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
}
extension PreviewVC: previewViewPresenterProtocol{
   
    func configure(model: TitlePreviewModel?) {
        movieTitle.text = model?.title
        preview.text = model?.titleOverview
        let youtubeURL = String(format: "%@%@", "https://www.youtube.com/embed/", model?.youtubeView.id.videoId ?? "")
        guard let url = URL(string: youtubeURL) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
}
extension PreviewVC{
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
