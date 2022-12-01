//
//  MainScreenModuleService.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 27.11.2022.
//

import Foundation

enum NetworkingErrors: Error {
    case maxRequests
}

protocol MainScreenModuleNetworkServiceProtocol: AnyObject {
    func getNews(query: String, page: Int, sortingMethod: MainScreenDataSortingMethods, completion: @escaping(Result<MainScreenNews, NetworkingErrors>) -> Void)
    func applyFilters(filter: String, completion: @escaping(MainScreenNews) -> Void)
}

final class MainScreenModuleNetworkService: RestAPI {
    func linkString(with query: String) -> String {
        return baseURL + "everything?q=" + query + "&\(token)" + "&pageSize=\(stadartPageSize)"
    }
    
    func linkStringForFilters(filter: String) -> String {
        return baseURL + "top-headlines?" + filter.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + token
    }
}

extension MainScreenModuleNetworkService: MainScreenModuleNetworkServiceProtocol {
    func getNews(query: String, page: Int, sortingMethod: MainScreenDataSortingMethods, completion: @escaping(Result<MainScreenNews, NetworkingErrors>) -> Void) {
        let url = URL(string: linkString(with: query) + "&sortBy=\(sortingMethod.rawValue)" + "&page=\(page)")
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        print(url)
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
    
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse  else { return }
            guard (200...299).contains(httpResponse.statusCode) else {
                print(httpResponse.statusCode)
                DispatchQueue.main.async {
                    completion(.failure(.maxRequests))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(APIArrayHomeModuleResponce<MainScreenModel>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.articles))
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func applyFilters(filter: String, completion: @escaping(MainScreenNews) -> Void) {
        let url = URL(string: linkStringForFilters(filter: filter))
        guard let url = url else { return }
        print(url)
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(APIArrayHomeModuleResponce<MainScreenModel>.self, from: data)
                DispatchQueue.main.async {
                    completion(result.articles)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
