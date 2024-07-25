//
//  UpcomingVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 25/07/2024.
//

import UIKit

class UpcomingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        setupUI()
    }
    
    private func setupUI(){
        let nib = UINib(nibName: String(describing: UpcomingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
}

extension UpcomingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell
        else {return UITableViewCell()}
        
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
            <#code#>
        }
    }
}
