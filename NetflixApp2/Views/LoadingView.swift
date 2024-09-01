//
//  LoadView.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 31/08/2024.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    enum Configuration {
        static let cornerRadius: CGFloat = 10.0
        static let alpha: CGFloat = 0.8
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = Configuration.cornerRadius
        alpha = Configuration.alpha
        isHidden = true
    }
    
    static func initToView(_ view: UIView, loadingText: String = "Loading...") -> LoadingView {
        guard let loadingView: LoadingView = UIView.instanceFromNib() else {
            fatalError("Unable to allocate Loading View")
        }
        
        loadingView.loadingLabel.text = loadingText
        loadingView.isHidden = true
        loadingView.center = view.center
        view.addSubview(loadingView)
        
        return loadingView
    }
    
    func show() {
        isHidden = false
    }
    
    func hide() {
        isHidden = true
    }
}


extension UIView {
    static func instanceFromNib<T>() -> T? {
        return UINib(nibName: String(describing: T.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? T
    }
}
