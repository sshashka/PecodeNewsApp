//
//  SavedNewsPresenter.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation

protocol SavedNewsPresenterProtocol: AnyObject {
    func loadNews()
}

protocol SavedNewsViewProtocol: AnyObject {
    func showNews(news: [SavedNewsModel])
}

final class SavedNewsPresenter {
    let coreDataManager: CoreDataManagerProtocol
    weak var view: SavedNewsViewProtocol?
    
    init(coreDataManager: CoreDataManagerProtocol, view: SavedNewsViewProtocol) {
        self.coreDataManager = coreDataManager
        self.view = view
    }
}

extension SavedNewsPresenter: SavedNewsPresenterProtocol {
    func loadNews() {
        let data = coreDataManager.getSavedNews()
        guard let data = data else { return }
        view?.showNews(news: data)
    }
}
