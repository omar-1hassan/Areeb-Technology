//
//  RepositryData.swift
//  AreebTechnology
//
//  Created by mac on 16/10/2023.
//

import Foundation

struct Repository: Codable {
    let name: String?
    let owner: Owner?
    let url: String?
    var created_at: String?
}

struct Owner: Codable{
    let login: String?
    let avatar_url: String?
}
