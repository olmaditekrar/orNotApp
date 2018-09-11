//
//  userSearchResultCell.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 29.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class userSearchResultCell: UITableViewCell {

    @IBAction func followBtnPressed(_ sender: Any) {
        
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(name :String,userPhoto : UIImageView) {
        self.userPhoto = userPhoto
        self.name.text = name
       
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
