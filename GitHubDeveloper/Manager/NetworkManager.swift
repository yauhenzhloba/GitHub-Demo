//
//  NetworkService.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 3/31/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import Foundation
import Alamofire
//let data = try encoder.encode(employee)

class NetworkManager{
    
    static let shared = NetworkManager()
    
    typealias UsersCompletion = ([GitHubUser]?) -> Void
    typealias UserDictionaryCompletion = (GitHubUserDecription?) -> Void
    typealias ReposCompletion = ([GitHubRepo]?) -> Void
    
    //https://api.github.com/users/cheshire137/followers
    //https://api.github.com/users/joekr/followers
    
    func getUsers(onSuccess: @escaping(UsersCompletion), onError: @escaping(_ errorMessage: String) -> Void){
        Alamofire.request("https://api.github.com/users/cheshire137/followers").responseJSON { (response) in
            if let error = response.error {
                onError(error.localizedDescription)
            } else if let result = response.data {
                do {
                let users = try JSONDecoder().decode([GitHubUser].self, from: result)
                    onSuccess(users)
                } catch {
                    onError("Error catch. Try again later.")
                }
            }
        }
    }
    
    func getUserDictionary(url: String, onSuccess: @escaping(UserDictionaryCompletion), onError: @escaping(_ errorMessage: String) -> Void){
        Alamofire.request(url).responseJSON { (response) in
            print(response.result.value)
            if let error = response.error {
                onError(error.localizedDescription)
                print(error.localizedDescription)
            } else if let result = response.data {
                do {
                let user = try JSONDecoder().decode(GitHubUserDecription.self, from: result)
                    onSuccess(user)
                } catch {
                    print("Error catch. Try again later.")
                    onError("Error catch. Try again later.")
                }
            }
        }
    }
    
    func getRepos(url: String, onSuccess: @escaping(ReposCompletion), onError: @escaping(_ errorMessage: String) -> Void){
        Alamofire.request(url).responseJSON { (response) in
            if let error = response.error {
                onError(error.localizedDescription)
            } else if let result = response.data {
                do {
                let repos = try JSONDecoder().decode([GitHubRepo].self, from: result)
                    onSuccess(repos)
                } catch {
                    onError("Error catch. Try again later.")
                }
            }
        }
    }
    
    
}

