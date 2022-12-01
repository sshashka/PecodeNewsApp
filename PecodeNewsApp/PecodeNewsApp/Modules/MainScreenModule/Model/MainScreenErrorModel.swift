//
//  MainScreenErrorModel.swift
//  PecodeNewsApp
//
//  Created by Саша Василенко on 29.11.2022.
//

import Foundation

struct MainScreenErrorModel: Codable {
    let status: String
    let code: String
    let message: String
}
