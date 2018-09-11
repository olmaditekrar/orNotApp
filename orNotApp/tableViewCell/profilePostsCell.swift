//
//  profilePostsCell.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase

class profilePostsCell: UITableViewCell {

   
    @IBOutlet weak var optionTwo: UIButton!
    @IBOutlet weak var optionOne: UIButton!
    

    @IBOutlet weak var colone2: UIImageView!
    @IBOutlet weak var colone1: UIImageView!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var name: UILabel!
    let uid = Auth.auth().currentUser?.uid
    var rateOfOptionOne = ""
    var rateOfOptionTwo = ""
    @IBAction func optionOnePressed(_ sender: Any) {
       
    }
    @IBAction func optionTwoPressed(_ sender: Any) {
              //    let roundedValue1 = NSString(format: "%.2f", optionOneRate)
              //  let roundedValue2 = NSString(format: "%.2f", optionTwoRate)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255,blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }
}
