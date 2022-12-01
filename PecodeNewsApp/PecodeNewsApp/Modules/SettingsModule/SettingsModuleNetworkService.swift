//
//  SettingsModuleNetworkService.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation

protocol SettingsModuleNetworkServiceProtocol: AnyObject {
    func getSources(completion: @escaping([SourcesModel]) -> Void)
}

class SettingsModuleNetworkService: RestAPI {
    func linkString() -> String {
        return baseURL + "top-headlines/sources?" + token
    }
}

extension SettingsModuleNetworkService: SettingsModuleNetworkServiceProtocol {
    func getSources(completion: @escaping([SourcesModel]) -> Void) {
        let url = URL(string: linkString())
        guard let url = url else { return }
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { data, responce, error in
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(APIArraySourcesResponce<SourcesModel>.self, from: data)
                DispatchQueue.main.async {
                    completion(result.sources)
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
