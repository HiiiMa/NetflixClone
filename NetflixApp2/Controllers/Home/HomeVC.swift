//
//  HomeVC.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit

protocol HomeViewProtocol: AnyObject {
    func setupHeaderView()
}

final class HomeVC: UIViewController {
    
    private var presenter: HomeViewPresenterProtocol!
 
    @IBOutlet private weak var tableView: UITableView!
    //MARK: This is the life cycle method for the view controller. ViewDidLoad is only called once, while viewWillApear is called right before the view is add to it's view hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = HomeViewPresenter(view: self)
        presenter.getData()
        ConfigureNavBar()
        setupHeaderView()
    }
}

private extension HomeVC {
   
    func setupView() {
        //when passing a cell:- Create a nib then pass the nib to the register instead of "HomeCell.self"
        let nib = UINib(nibName: String(describing: HomeCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HomeCell")
        
        tableView.delegate = self
        tableView.dataSource = self

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
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            cell.configure(with: presenter.trendingMovies ?? [])
            return cell
        case Sections.TrendingTv.rawValue:
            cell.configure(with: presenter.trendingTv ?? [])
            return cell
        case Sections.Popular.rawValue:
            cell.configure(with: presenter.popular ?? [])
            return cell
        case Sections.Upcoming.rawValue:
            cell.configure(with: presenter.upComming ?? [])
            return cell
        case Sections.TopRated.rawValue:
            cell.configure(with: presenter.topRated ?? [])
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

extension HomeVC: HomeCellDelegate{
    func homeCellDidTapCell(model: Title) {
        let storyboard = UIStoryboard(name: "PreviewVC", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PreviewVC") as! PreviewVC
        vc.movieData = model
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: HomeViewProtocol {
    func setupHeaderView() {
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        let model = presenter.headerViewImage ?? ""
        headerView.configure(with: model)
        tableView.tableHeaderView = headerView
        tableView.reloadData()
    }
}
