//
//  GitHubRepo.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import Foundation

struct GitHubRepo: Decodable {
    
    var repoName: String?
    var repoHtml: String?
    var repoDescription: String?
    var repoLanguage: String?
    var forks: Int?
    var stars: Int?

    enum CodingKeys: String, CodingKey {
        case repoName = "name"
        case repoHtml = "html_url"
        case forks = "forks"
        case stars = "stargazers_count"
        case repoDescription = "description"
        case repoLanguage = "language"
    }
    
}
