//
//  Extension.swift
//  GitHubDeveloper
//
//  Created by EUGENE on 4/1/20.
//  Copyright © 2020 Yauhen Zhloba. All rights reserved.
//

import SDWebImage

extension UIImageView {
    
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else {return}
        guard let url = URL(string: string) else {return}
        
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
}
