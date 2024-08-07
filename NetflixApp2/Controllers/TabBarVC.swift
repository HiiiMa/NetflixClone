//
//  ViewController.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 23/07/2024.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    func setUpUI(){
        
        let HomeView = UINavigationController(rootViewController: HomeVC())
        let Upcoming = UINavigationController(rootViewController: UpcomingVC())
        let Search = UINavigationController(rootViewController: SearchVC())
        let Downloads = UINavigationController(rootViewController: UIViewController())
        
        HomeView.tabBarItem.image = UIImage(systemName: "house")
        HomeView.tabBarItem.title = "Home"
        
        Upcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        Upcoming.tabBarItem.title = "Upcoming"
        
        Search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        Search.tabBarItem.title = "Search"
        
        Downloads.tabBarItem.image = UIImage(systemName: "arrow.down")
        Downloads.tabBarItem.title = "Downloads"
        
        setViewControllers([HomeView,Upcoming,Search,Downloads], animated: true)
        
        tabBar.tintColor = .label
    }
}

