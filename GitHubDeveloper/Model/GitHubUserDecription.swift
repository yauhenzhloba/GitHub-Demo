//
//  GitHubUserDecription.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import Foundation

struct GitHubUserDecription: Decodable {

    var name: String?
    var login: String?
    var avatarUrl: String?
    var url: String?
    var joinDate: String?
    var gistsUrl: String?
    var location: String?
    var email: String?
    var followers: Int?
    var following: Int?
    var publicRepos: Int?
    var bio: String?
    var reposUrl: String?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case login = "login"
        case avatarUrl = "avatar_url"
        case url = "url"
        case location = "location"
        case email = "email"
        case followers = "followers"
        case following = "following"
        case publicRepos = "public_repos"
        case bio = "bio"
        case reposUrl = "repos_url"
        case joinDate = "created_at"

    }

}
