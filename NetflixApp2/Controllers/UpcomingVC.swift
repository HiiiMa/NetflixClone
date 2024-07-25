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
        
        guard let model = upComing?[indexPath.row].poster_path else {
            return UITableViewCell()
        }
        cell.configureImage(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
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
                DispatchQueue.main.async { [weak self] in
                    self?.setupUI()
                    self?.tableView.reloadData()
                }
            }
        }
    }
}
