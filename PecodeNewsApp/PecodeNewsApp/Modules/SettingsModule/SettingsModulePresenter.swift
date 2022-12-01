//
//  SettingsModulePresenter.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation
protocol SettingsModulePresenterProtocol: AnyObject {
    func getSettings()
    func getCountries()
    func getTopics()
    func didChangeFilter(filter: MainScreenDataFilteringMethods, with: Int)
}

protocol SettingsModuleViewProtocol: AnyObject {
    func showSources(sources: [SourcesModel])
    func showCountries(countries: [Country])
    func showTopics(topics: [TopicsModel])
}

final class SettingsModulePresenter: SettingsModulePresenterProtocol {
    
    private var sources: [SourcesModel]?
    private var countries: [Country]?
    private var topics: [TopicsModel]?
    weak var view: SettingsModuleViewProtocol?
    let networkService: SettingsModuleNetworkServiceProtocol
    
    init(view: SettingsModuleViewProtocol, networkService: SettingsModuleNetworkServiceProtocol) {
        self.view = view
        self.networkService = networkService
    }
    
    func getSettings() {
        networkService.getSources {[weak self] result in
            self?.view?.showSources(sources: result)
            self?.sources = result
            self?.getCountries()
        }
        
    }
    
    func getCountries() {
        countries = Country.allCases.map { country in
            country
        }
        guard let countries = countries else { return }
        view?.showCountries(countries: countries)
        getTopics()
    }
    
    func getTopics() {
        topics = TopicsModel.allCases.map({ topic in
            topic
        })
        guard let topics = topics else { return }
        view?.showTopics(topics: topics)
    }
    
    func didChangeFilter(filter: MainScreenDataFilteringMethods, with index: Int) {
        let userDefaults = UserDefaults.standard
        switch filter {
        case .byTopics:
            guard let topics = topics else { return }
            let value = topics[index].rawValue
            userDefaults.set(value, forKey: MainScreenDataFilteringMethods.byTopics.rawValue)
            print("Lol")
        case .byCountry:
            guard let countries = countries else { return }
            let value = countries[index].rawValue
            userDefaults.set(value, forKey: MainScreenDataFilteringMethods.byCountry.rawValue)
        case .bySources:
            guard let sources = sources else { return }
            let value = sources[index].name
            userDefaults.set(value, forKey: MainScreenDataFilteringMethods.bySources.rawValue)
        }
    }
}

private extension SettingsModulePresenter {
    
}
