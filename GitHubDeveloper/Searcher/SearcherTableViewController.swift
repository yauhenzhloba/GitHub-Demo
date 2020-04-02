//
//  SearcherTableViewController.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import UIKit
import JGProgressHUD

class SearcherTableViewController: UITableViewController, UISearchBarDelegate {

    var users = [GitHubUser]()
    var filtered = [GitHubUser]()
    var searchActive : Bool = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }

    //MARK: - Network Manager
    func fetchUsers(){
        self.hud.show(in: self.view)
        NetworkManager.shared.getUsers(onSuccess: { (result) in
            self.successHud()
            self.users = result!
            self.tableView.reloadData()
            self.successHud()
        }) { (error) in
            self.errorHud(errorMessage: error)
        }
    }
    
    //MARK: - Progress Hud
    var hud = JGProgressHUD(style: .dark)
    
    func errorHud(errorMessage: String) {
        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        self.hud.textLabel.text = errorMessage
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 3.0)
    }
    func successHud(){
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.textLabel.text = ""
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 3.0)
    }
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                filtered = self.users.filter { (user: GitHubUser) -> Bool in
                    return user.login!.lowercased().contains(searchText.lowercased())
         }
         if(filtered.count == 0){
             searchActive = false
            print("count false")
         } else {
             searchActive = true
            print("count true")
         }
         self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearcherTableViewCell
        if(searchActive){
            cell.userLogin?.text = filtered[indexPath.row].login
            cell.userImage.loadImage(filtered[indexPath.row].avatarUrl)
        } else {
        cell.userLogin?.text = users[indexPath.row].login
        cell.userImage.loadImage(users[indexPath.row].avatarUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userUrl = ""
        if(searchActive){
            userUrl = filtered[indexPath.row].url!
        } else {
            userUrl = users[indexPath.row].url!
        }
        if userUrl != "" {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userDetailsVC") as! UserDetailsViewController
            vc.self.userApiUrl = userUrl
            //vc.self.imagePartner = cell.profileImageView.image
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userDetailsVC") as! UserDetailsViewController
            vc.self.userApiUrl = "nil"
            //vc.self.imagePartner = cell.profileImageView.image
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }

}
