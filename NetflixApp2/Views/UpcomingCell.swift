//
//  UpcomingCell.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 25/07/2024.
//

import UIKit

class UpcomingCell: UITableViewCell {
    private var titles: [Title] = [Title]()
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //posterImageView.image = UIImage(named: "poster")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func configure(with titles: [Title]) {
        self.titles = titles
    }
    public func configureImage(with model: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }

    
}
