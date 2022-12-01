//
//  MainScreenViewController+Modulr.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 28.11.2022.
//

import Foundation

extension MainScreenViewController {
    static var module: MainScreenViewController {
        let vc = MainScreenViewController()
        let networkService = MainScreenModuleNetworkService()
        let coreDataManager = CoreDataManager()
        let presenter = MainScreenModulePresenter(service: networkService, view: vc, coreDataManager: coreDataManager)
        vc.presenter = presenter
        return vc
    }
}
