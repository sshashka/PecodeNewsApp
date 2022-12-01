//
//  API.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 27.11.2022.
//

import Foundation

class RestAPI {
    let baseURL = "https://newsapi.org/v2/"
    let token = "apiKey=6a275ba7b8684adaac457ff02bedd9b6"
    let stadartPageSize = 10
}

struct APIArrayHomeModuleResponce<Data: Codable>: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Data]
}

struct APIArraySourcesResponce<Data: Codable>: Codable {
    let status: String
    let sources: [Data]
}
