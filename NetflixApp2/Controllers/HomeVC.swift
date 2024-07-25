//
//  HomeVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

final class HomeVC: UIViewController {
//MARK: Variables for API Data:
    private let dispatchGroup = DispatchGroup()
    private var trendingMovies: [Title]?
    private var trendingTv: [Title]?
    private var popular: [Title]?
    private var upComming: [Title]?
    private var topRated: [Title]?
    
    private let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    @IBOutlet private weak var tableView: UITableView!
//MARK: This is the life cycle method for the view controller. ViewDidLoad is only called once, while viewWillApear is called right before the view is add to it's view hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        ConfigureNavBar()
        GetData()
        setupHeaderView()
    }
}

private extension HomeVC {
    func setupHeaderView() {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        tableView.tableHeaderView = headerView
    }
    
    func setupView() {
        //when passing a cell:- Create a nib then pass the nib to the register instead of "HomeCell.self"
        let nib = UINib(nibName: String(describing: HomeCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        //view.backgroundColor = .systemBackground
        
        tableView.reloadData()
    }
    
    func ConfigureNavBar() {
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = 
        [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    func GetData(){
        dispatchGroup.enter()
        getTrendingMovies { [weak self] in
            guard let self else { return }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getTrendingTv { self.dispatchGroup.leave() }
        
        dispatchGroup.enter()
        getPopular { self.dispatchGroup.leave() }
        
        dispatchGroup.enter()
        getUpComming { self.dispatchGroup.leave() }
        
        dispatchGroup.enter()
        getTopRated { self.dispatchGroup.leave() }
        
        dispatchGroup.notify(queue: .main) { // Add weak self
            self.tableView.reloadData()
        }
    }
}
extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as? HomeCell
        else {
            return UITableViewCell()
        }
        
        cell.configureCell()
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            cell.configure(with: trendingMovies ?? [])
            return cell
        case Sections.TrendingTv.rawValue:
            cell.configure(with: trendingTv ?? [])
            return cell
        case Sections.Popular.rawValue:
            cell.configure(with: popular ?? [])
            return cell
        case Sections.Upcoming.rawValue:
            cell.configure(with: upComming ?? [])
            return cell
        case Sections.TopRated.rawValue:
            cell.configure(with: topRated ?? [])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
}

extension HomeVC {
   //MARK: - Placing API Data in local variables
    func getTrendingMovies(completion: @escaping ()-> Void){
        APICaller.shared.getTrendingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingMovies = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getTrendingTv(completion: @escaping ()-> Void){
        APICaller.shared.getTrendingTvs { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                trendingTv = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getPopular(completion: @escaping ()-> Void){
        APICaller.shared.getPopular { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                popular = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getUpComming(completion: @escaping ()-> Void){
        APICaller.shared.getUpcomingMovies { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                upComming = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    func getTopRated(completion: @escaping ()-> Void){
        APICaller.shared.getTopRated { [weak self] result in
            guard let self else{return}
            switch result {
            case .success(let titles):
                topRated = titles
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
}


/*
 MARK: - Old API code inside cellForRowAt method:
 
 switch indexPath.section {
 case Sections.TrendingMovies.rawValue:
//MARK: - This closure is marked with @escaping making it able to capture the data and not just dissapear after the function call ends.
     APICaller.shared.getTrendingMovies { result in
         switch result {
             
         case .success(let titles):
             cell.configure(with: titles)
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
     
     
     
 case Sections.TrendingTv.rawValue:
     APICaller.shared.getTrendingTvs { result in
         switch result {
         case .success(let titles):
             cell.configure(with: titles)
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
 case Sections.Popular.rawValue:
     APICaller.shared.getPopular { result in
         switch result {
         case .success(let titles):
             cell.configure(with: titles)
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
 case Sections.Upcoming.rawValue:
     
     APICaller.shared.getUpcomingMovies { result in
         switch result {
         case .success(let titles):
             cell.configure(with: titles)
         case .failure(let error):
             print(error.localizedDescription)
         }
     }
     
 case Sections.TopRated.rawValue:
     APICaller.shared.getTopRated { result in
         switch result {
         case .success(let titles):
             cell.configure(with: titles)
         case .failure(let error):
             print(error)
         }
     }
 default:
     return UITableViewCell()

 }
 */
