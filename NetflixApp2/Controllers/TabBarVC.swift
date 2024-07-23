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
        view.backgroundColor = .systemYellow
        
        let HomeView = UINavigationController(rootViewController: HomeVC())
        
        HomeView.tabBarItem.image = UIImage(systemName: "house")
        HomeView.tabBarItem.title = "Home"
        
        setViewControllers([HomeView], animated: true)
        
        tabBar.tintColor = .label
    }
}

