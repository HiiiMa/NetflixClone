//
//  PreviewVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 28/07/2024.
//
import WebKit
import UIKit

class PreviewVC: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var preview: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
   
    private var titles: [Title]?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        title = "Preview"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    public func configure(with model: TitlePreviewViewModel) {
        movieTitle.text = model.title
        preview.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}

