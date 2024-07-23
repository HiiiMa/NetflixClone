//
//  HomeCell.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit

class HomeCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    private var titles: [Title] = [Title]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell() {
        let nib = UINib(nibName: "TestCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "TestCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension HomeCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionCell", for: indexPath) as? TestCollectionCell
        else { return UICollectionViewCell() }
        
        //Erorr index out of bounds
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        
        return cell
    }

//    // This Function can setup collectionView layout using UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,              sizeForItemAt indexPath: IndexPath) -> CGSize {
//        .init(width: 20, height: 20)
//    }

}
