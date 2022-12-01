//
//  TabBarController.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        setupVC()
        // Do any additional setup after loading the view.
    }
    
    private func setupVC() {
        viewControllers = [createNavVC(for: MainScreenViewController.module, title: "Home", image: UIImage(systemName: "house")!, navVCTitle: "Home"), createNavVC(for: SavedNewsViewController.module, title: "Saved", image: UIImage(systemName: "externaldrive.fill")!, navVCTitle: "Saved news"), createNavVC(for: SettingsViewController.module, title: "Settings", image: UIImage(systemName: "gear")!, navVCTitle: "Filter settings")]
    }
    
    func createNavVC(for rootVC: UIViewController, title: String, image: UIImage, navVCTitle: String) -> UIViewController {
        let navVC = UINavigationController(rootViewController: rootVC)
        navVC.visibleViewController?.title = navVCTitle
        navVC.tabBarItem.image = image
        navVC.tabBarItem.title = title
        return navVC
    }
}
