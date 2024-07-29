//
//  HomeCell.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit
//MARK: Views are " What The User Sees" (UI)
protocol HomeCellDelegate: AnyObject{
    func HomeCellDidTapCell(_ cell: HomeCell, viewModel: TitlePreviewViewModel)
}
class HomeCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var titles: [Title] = [Title]()
    
    public weak var delegate: HomeCellDelegate?
    
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
        //Because it will be called in APICaller, thus it will be excuted in a background thread, so we call DispatchQueue.main.async to excute it on the main thread since it's a UI call (GCD), we add [weak self] to make it a weak refrence so we can prevent retain cycles.
            collectionView.reloadData()
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                guard let titleOverview = title?.overview else {
                    return
                }
                guard let self else {
                    return
                }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                DispatchQueue.main.async{[weak self] in
                    guard let self else{
                        return
                    }
                    delegate?.HomeCellDidTapCell(HomeCell(), viewModel: viewModel)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
//    // This Function can setup collectionView layout using UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,              sizeForItemAt indexPath: IndexPath) -> CGSize {
//        .init(width: 20, height: 20)
//    }

}
