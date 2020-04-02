//
//  SearcherTableViewCell.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import UIKit

class SearcherTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLogin: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.cornerRadius = 5
        selectLabel.layer.cornerRadius = 3
        selectLabel.layer.borderColor = UIColor.lightGray.cgColor
        selectLabel.layer.borderWidth = 1
    }

}
