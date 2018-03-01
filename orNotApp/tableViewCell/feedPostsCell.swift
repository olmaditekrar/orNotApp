//
//  feedPostsCell.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 28.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class feedPostsCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var buttons: UIStackView!
    
    @IBOutlet weak var disliked: UILabel!
    @IBOutlet weak var liked: UILabel!
    @IBOutlet weak var colone2: UIImageView!
    @IBOutlet weak var colone1: UIImageView!
   
    func UpdateViews(category : Category){
        disliked.text = category.negativeStatus
        liked.text = category.positiveStatus
        //colone2.image = UIImage(named: category.colone2name)
        //colone1.image = UIImage(named: category.colone1bame)
        label.text = category.post
        
        
        
    }

}
