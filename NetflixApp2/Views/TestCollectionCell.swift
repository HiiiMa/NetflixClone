//
//  TestCollectionCell.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit
import SDWebImage

class TestCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(with model: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        imageView.sd_setImage(with: url, completed: nil)
    }

}
