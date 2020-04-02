//
//  RepoTableViewCell.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var repoConteinerView: UIView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoLinkHtml: UILabel!
    @IBOutlet weak var repoDescrition: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoForks: UILabel!
    @IBOutlet weak var repoStars: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        repoConteinerView.layer.cornerRadius = 5
        repoConteinerView.layer.borderWidth = 1
        repoConteinerView.layer.borderColor = UIColor.lightGray.cgColor
    }

}
