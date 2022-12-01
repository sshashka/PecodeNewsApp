//
//  SettingsModel.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 30.11.2022.
//

import Foundation

struct SourcesModel: Codable, Hashable {
    let id, name, sourceDescription: String
    let url: String
    let category, language, country: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case sourceDescription = "description"
        case url, category, language, country
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
