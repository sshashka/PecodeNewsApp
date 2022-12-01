//
//  SavedNewsViewController+Module.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation

extension SavedNewsViewController {
    static var module: SavedNewsViewController {
        let coreDataManager = CoreDataManager()
        let vc = SavedNewsViewController()
        let presenter = SavedNewsPresenter(coreDataManager: coreDataManager, view: vc)
        vc.presenter = presenter
        return vc
    }
}
