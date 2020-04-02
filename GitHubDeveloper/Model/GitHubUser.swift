//
//  GitHubUser.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 3/31/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import Foundation

struct GitHubUser: Decodable {
    
    var login: String?
    var avatarUrl: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
    }
    
}



