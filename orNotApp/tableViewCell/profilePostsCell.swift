//
//  profilePostsCell.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class profilePostsCell: UITableViewCell {

    @IBOutlet weak var negativeStatus: UILabel!
    @IBOutlet weak var positiveStatus: UILabel!
    @IBOutlet weak var colone2: UIImageView!
    @IBOutlet weak var colone1: UIImageView!
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var post: UILabel!
    func UpdateViews(category : Category){
        negativeStatus.text = category.negativeStatus
        positiveStatus.text = category.positiveStatus
        colone2.image = UIImage(named: category.colone2name)
        colone1.image = UIImage(named: category.colone1bame)
        post.text = category.post
        
        
        
    }
}
