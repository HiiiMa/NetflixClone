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
        //view.backgroundColor = .systemYellow
        
        let HomeView = UINavigationController(rootViewController: HomeVC())
        let Upcoming = UINavigationController(rootViewController: UpcomingVC())
        
        HomeView.tabBarItem.image = UIImage(systemName: "house")
        HomeView.tabBarItem.title = "Home"
        
        Upcoming.tabBarItem.image = UIImage(systemName: "play.circle")
        Upcoming.tabBarItem.title = "Upcoming"
        
        setViewControllers([HomeView,Upcoming], animated: true)
        
        tabBar.tintColor = .label
    }
}

