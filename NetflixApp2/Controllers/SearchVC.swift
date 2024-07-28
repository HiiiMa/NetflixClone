//
//  SearchVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 28/07/2024.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    //MARK: - Outles
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    //MARK: - Variables
    private var upComing: [Title]?
    private var searchedResults: [Title] = []
    // This is a flag that determines if to show all the results or only the searched results
    private var isSearching = false {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        GetData()
    }
    
    private func setupUI(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let nib = UINib(nibName: String(describing: UpcomingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        tableView.reloadData()
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activeDataset().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell
        else {return UITableViewCell()}
        cell.configure(with: upComing ?? [])
        guard let model = upComing?[indexPath.row] else {return UITableViewCell() }
        
        cell.configureImage(with: TitleViewModel(titleName: model.original_title ?? model.original_name ?? "Unknown title", posterURL: model.poster_path ?? ""))
//MARK: - SearchBar vars:
        let titles = activeDataset()
        _ = titles[indexPath.row] // Get data for the row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
//MARK: - Fetching PosterImage Data:
extension SearchVC {
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
//MARK: - Setting up SearchBar:
extension SearchVC {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText != "" else{
            isSearching = false
            searchedResults.removeAll()
            return
        }
        searchedResults = filteredTitles(query: searchText)
        isSearching = true
        
    }
    /// Retuns active dataset based on the search state
    func activeDataset() -> [Title] {
        if isSearching {
            return searchedResults
        } else {
            return upComing ?? []
        }
    }
    /// Returns a list of univerties matching given query
    /// Logical Error, search results is wrong
    func filteredTitles(query: String) -> [Title] {
        return upComing?.filter { ($0.original_title!).range(of: searchBar.text ?? "", options: [ .caseInsensitive, .diacriticInsensitive ]) != nil } ?? []
    }
}


