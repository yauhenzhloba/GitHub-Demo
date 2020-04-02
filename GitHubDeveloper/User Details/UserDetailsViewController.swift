//
//  UserDetailsViewController.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import UIKit
import WebKit
import JGProgressHUD

class UserDetailsViewController: UIViewController, UISearchBarDelegate {

    var userApiUrl = ""
    
    @IBOutlet weak var imageConteinerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userJoinDateLabel: UILabel!
    @IBOutlet weak var userFollowersConteinerView: UIView!
    @IBOutlet weak var userFollowersLabel: UILabel!
    @IBOutlet weak var userFollowingConteinerView: UIView!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var userBioTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userBioHeightsConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive : Bool = false
    
    var repos = [GitHubRepo]()
    var filtered = [GitHubRepo]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.setupUI()
        self.fetchUserFields()
    }

    //MARK: - UI
    func setupUI(){
        self.navigationController?.navigationBar.topItem?.title = "Search"
        self.imageConteinerView.layer.cornerRadius = 5
        
        self.userFollowersConteinerView.layer.cornerRadius = 3
            self.userFollowersConteinerView.layer.borderColor = UIColor.darkGray.cgColor
        self.userFollowersConteinerView.layer.borderWidth = 1

        self.userFollowingConteinerView.layer.cornerRadius = 3
            self.userFollowingConteinerView.layer.borderColor = UIColor.darkGray.cgColor
        self.userFollowingConteinerView.layer.borderWidth = 1
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
    
    //MARK: - Network Manager
    func fetchUserFields(){
        if userApiUrl != "" {
            self.hud.show(in: self.view)
            NetworkManager.shared.getUserDictionary(url: self.userApiUrl, onSuccess: { (user) in
                if user != nil {
                    self.getUserFields(user: user!)
                    self.successHud()
                } else {
                    self.errorHud(errorMessage: "user Not Found")
                }
            }) { (error) in
                self.errorHud(errorMessage: error)
            }
        }
    }
    
    func fetchRepos(url: String){
        self.hud.show(in: self.view)
        NetworkManager.shared.getRepos(url: url, onSuccess: { (result) in
            self.successHud()
            self.repos = result!
            self.tableView.reloadData()
        }) { (error) in
            self.errorHud(errorMessage: error)
        }
        
    }
    
    //MARK: - User UI Fields
    func getUserFields(user: GitHubUserDecription){
        if user.reposUrl != nil {
            self.fetchRepos(url: (user.reposUrl)!)
        }
        self.userImageView.loadImage(user.avatarUrl)
        self.userLoginLabel.text = user.login
        self.userFullNameLabel.text = user.name
        self.userLocationLabel.text = user.location
        
        var intFollower :Int = (user.followers)!
        var stringFollower :String = "Followers " + String(intFollower)
        self.userFollowersLabel.text = stringFollower
        intFollower = (user.following)!
        stringFollower = String(intFollower) + " Following"
        self.userFollowingLabel.text = stringFollower
        
        if user.bio == nil {
            self.userBioHeightsConstraint.constant = 0
            self.view.layoutIfNeeded()
        } else {
            self.userBioTextView.text = user.bio
            self.textViewDidChange(self.userBioTextView)
            self.view.layoutIfNeeded()
        }

        self.getDate(dateString: user.joinDate!)
    }
    
    func getDate(dateString: String){
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from:dateString)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.userJoinDateLabel.text = "Join " + dateFormatter.string(from: (date))
    }
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
                filtered = self.repos.filter { (repo: GitHubRepo) -> Bool in
                    return repo.repoName!.lowercased().contains(searchText.lowercased())
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

}

    //MARK: - TableView DataSource
extension UserDetailsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as! RepoTableViewCell
        if(searchActive){
            cell.repoNameLabel.text = self.filtered[indexPath.row].repoName
            cell.repoLinkHtml.text = self.filtered[indexPath.row].repoHtml
            cell.repoDescrition.text = self.filtered[indexPath.row].repoDescription
            if cell.repoDescrition.text == "" {
                cell.repoDescrition.text = "..."
            }
            cell.repoLanguage.text = self.filtered[indexPath.row].repoLanguage
            let intForks: Int = (self.filtered[indexPath.row].forks)!
            let stringForks: String = String(intForks) + " Forks"
            cell.repoForks.text = stringForks
            let intStars: Int = (self.filtered[indexPath.row].stars)!
            let stringStars: String = String(intStars) + " Stars"
            cell.repoStars.text = stringStars
        } else {
            cell.repoNameLabel.text = self.repos[indexPath.row].repoName
            cell.repoLinkHtml.text = self.repos[indexPath.row].repoHtml
            cell.repoDescrition.text = self.repos[indexPath.row].repoDescription
            if cell.repoDescrition.text == "" {
                cell.repoDescrition.text = "..."
            }
            cell.repoLanguage.text = self.repos[indexPath.row].repoLanguage
            let intForks: Int = (self.repos[indexPath.row].forks)!
            let stringForks: String = String(intForks) + " Forks"
            cell.repoForks.text = stringForks
            let intStars: Int = (self.repos[indexPath.row].stars)!
            let stringStars: String = String(intStars) + " Stars"
            cell.repoStars.text = stringStars
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("open Html")
        if(searchActive){
            guard let url = URL(string: self.filtered[indexPath.row].repoHtml!) else { return }
            UIApplication.shared.open(url)
        } else {
            guard let url = URL(string: self.repos[indexPath.row].repoHtml!) else { return }
            UIApplication.shared.open(url)
        }
    }
    
}

// MARK: - Bio TextView Ext
extension UserDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ subtitleTextViewOutlet: UITextView) {
        let size = CGSize(width: self.userBioTextView.frame.width, height: .infinity)
        let estimateSize = self.userBioTextView.sizeThatFits(size)
        self.userBioHeightsConstraint.constant = estimateSize.height
        self.view.layoutIfNeeded()
    }
}
