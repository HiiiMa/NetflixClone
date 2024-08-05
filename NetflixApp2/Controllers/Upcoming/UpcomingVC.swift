//
//  UpcomingVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 25/07/2024.
//

import UIKit

final class UpcomingVC: UIViewController {
    //MARK: - Outles
    @IBOutlet private weak var tableView: UITableView!
    //MARK: - Variables
    private var upComing: [Title]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        GetData()
    }
    
    private func setupUI(){
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let nib = UINib(nibName: String(describing: UpcomingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
}

extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        upComing?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell
        else {return UITableViewCell()}
        cell.configure(with: upComing ?? [])
        guard let model = upComing?[indexPath.row] else {return UITableViewCell() }

        cell.configureImage(with: TitleModel(titleName: model.original_title ?? model.original_name ?? "Unknown title", posterURL: model.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = upComing?[indexPath.row]
        let storyboard = UIStoryboard(name: "PreviewVC", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.movieData = model
        navigationController?.pushViewController(vc, animated: true)
    }

}
//MARK: - Fetching PosterImage Data:
extension UpcomingVC {
    func getUpcoming(completion: @escaping ()-> ()){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else {return}
            switch result{
            case .success(let titles):
                upComing = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
            
        }
    }
    
    func GetData(){
        DispatchQueue.global(qos: .background).async {
            self.getUpcoming {
    //MARK: - After fetching the data, switch back to main thread and call setupUI.
                DispatchQueue.main.async { [weak self] in
                    guard let self else {return}
                    setupUI()
                    tableView.reloadData()
                }
            }
        }
    }
}
