//
//  SettingsViewController+Module.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation

extension SettingsViewController {
    static var module: SettingsViewController {
        let vc = SettingsViewController()
        let networkService = SettingsModuleNetworkService()
        let presenter = SettingsModulePresenter(view: vc, networkService: networkService)
        vc.presenter = presenter
        return vc
    }
}
