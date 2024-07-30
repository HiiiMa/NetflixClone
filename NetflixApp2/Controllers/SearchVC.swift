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
    private var discover: [Title]?
    private var searchedResults: [Title] = []
    // This is a flag that determines if to show all the results or only the searched results
    private var isSearching = false {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    private func setupUI(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let nib = UINib(nibName: String(describing: UpcomingCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UpcomingCell")
        searchedResults = discover ?? []
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        tableView.reloadData()
    }
    
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingCell", for: indexPath) as? UpcomingCell
        else {return UITableViewCell()}
        cell.configure(with: searchedResults)
        let model = searchedResults[indexPath.row]
        
        cell.configureImage(with: TitleModel(titleName: model.original_title ?? model.original_name ?? "Unknown title", posterURL: model.poster_path ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = searchedResults[indexPath.row]
        let storyBoard = UIStoryboard(name: "PreviewVC", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.movieData = model
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - Fetching PosterImage Data:
extension SearchVC {
    func getDiscover(completion: @escaping ()-> ()){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            guard let self else {return}
            switch result{
            case .success(let titles):
                discover = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
            
        }
    }
    
    func getData(){
        DispatchQueue.global(qos: .background).async {
            self.getDiscover {
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
            searchedResults = discover ?? []
            return
        }
        searchedResults = filteredTitles(query: searchText)
        isSearching = true
        
    }
    
    /// Returns a list of titles matching given query
    /// Logical Error, search results is wrong
    func filteredTitles(query: String) -> [Title] {
        return discover?.filter { ($0.original_title!).range(of: searchBar.text ?? "", options: [.caseInsensitive, .diacriticInsensitive] ) != nil || (($0.overview!).range(of: searchBar.text ?? "", options: [.caseInsensitive, .diacriticInsensitive] ) != nil) || (($0.release_date!).range(of: searchBar.text ?? "", options: [.caseInsensitive, .diacriticInsensitive] ) != nil)} ?? []
    }
}



