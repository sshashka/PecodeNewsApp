//
//  MainScreenModulePresenter.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 28.11.2022.
//

import Foundation

enum MainScreenDataFilteringMethods: String {
    case byTopics = "byCategory", byCountry = "byCountry", bySources = "bySources"
}

enum MainScreenDataSortingMethods: String {
    case popularity = "popularity", publishedAt = "publishedAt"
}

protocol MainScreenModulePresenterProtocol: AnyObject {
    func getNews()
    func sortTypeDidChange(sortingMethod: MainScreenDataSortingMethods)
    func filterMethodDidChange(filteringMethod: MainScreenDataFilteringMethods)
    func searchForNews(with query: String)
    func loadMoreNews()
    func saveArticle(article: MainScreenModel)
    func resfreshData()
}


protocol MainScreenModuleViewProtocol: AnyObject {
    func showNews(news: MainScreenNews)
    func showError(error: String)
    func addNews(news: MainScreenNews)
}


final class MainScreenModulePresenter: MainScreenModulePresenterProtocol {
    let service: MainScreenModuleNetworkServiceProtocol
    let coreDataManager: CoreDataManagerProtocol
    private var sortingMethod: MainScreenDataSortingMethods = .popularity
    private var filteringMethod: MainScreenDataFilteringMethods = .bySources
    private var page: Int = 1
    private var query: String = "bitcoin"
    weak var view: MainScreenModuleViewProtocol?
    
    init(service: MainScreenModuleNetworkServiceProtocol, view: MainScreenModuleViewProtocol, coreDataManager: CoreDataManagerProtocol) {
        self.service = service
        self.view = view
        self.coreDataManager = coreDataManager
    }
    
    func getNews() {
        service.getNews(query: query, page: page, sortingMethod: sortingMethod) {[weak self] result in
            switch result {
            case.success(let data):
                self?.view?.showNews(news: data)
            case .failure(let error):
                self?.view?.showError(error: error.localizedDescription)
            }
        }
    }
    
    func sortTypeDidChange(sortingMethod: MainScreenDataSortingMethods) {
        page = 1
        self.sortingMethod = sortingMethod
        getNews()
    }
    
    func filterMethodDidChange(filteringMethod: MainScreenDataFilteringMethods) {
        var filter = ""
        let userDefaults = UserDefaults.standard
        switch filteringMethod {
        case .byTopics:
            let value = userDefaults.string(forKey: MainScreenDataFilteringMethods.byTopics.rawValue)
            guard let value = value else { return }
            filter = "category=\(value)&"
        case .byCountry:
            let value = userDefaults.string(forKey: MainScreenDataFilteringMethods.byCountry.rawValue)
            guard let value = value else { return }
            filter = "language=\(value)&"
        case .bySources:
            let value = userDefaults.string(forKey: MainScreenDataFilteringMethods.bySources.rawValue)
            guard let value = value else { return }
            filter = "sources=\(value)&"
        }
        service.applyFilters(filter: filter, completion: {[weak self] result in
            self?.view?.showNews(news: result)
        })
    }
    
    func searchForNews(with query: String) {
        self.query = query
        getNews()
    }
    
    func loadMoreNews() {
        page += 1
        service.getNews(query: query, page: page, sortingMethod: sortingMethod) {[weak self] result in
            switch result {
            case.success(let data):
                self?.view?.addNews(news: data)
            case .failure(let error):
                self?.view?.showError(error: error.localizedDescription)
            }
        }
    }
    
    func saveArticle(article: MainScreenModel) {
        coreDataManager.save(article: article)
    }
    
    func resfreshData() {
        query = "bitcoin"
        sortingMethod = .popularity
        page = 1
        getNews()
    }
}
