//
//  MainTabBarControllerViewController.swift
//  BattleTest_V1
//
//  Created by ISRAEL GARCIA on 20/08/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        // Tab 1: Dashboard
        let dashboardVC = DashboardViewController()
        dashboardVC.tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Tab 2: Subjects
        let subjectsVC = SubjectsViewController()
        let subjectsNavController = UINavigationController(rootViewController: subjectsVC)
        subjectsNavController.tabBarItem = UITabBarItem(
            title: "Asignaturas",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )
        
        // Tab 3: Profile
        let profileVC = ProfileViewController()
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Perfil",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        // Configurar tabs
        viewControllers = [dashboardVC, subjectsNavController, profileNavController	]
        selectedIndex = 0
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = UIColor.systemBlue
        tabBar.backgroundColor = UIColor(named: "PrimaryBackground") ?? UIColor.systemBackground
    }
}
