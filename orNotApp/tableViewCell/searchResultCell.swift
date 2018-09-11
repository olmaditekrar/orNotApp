//
//  searchResultCellTableViewCell.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 27.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class searchResultCell: UITableViewCell {

    
    var followingsArray = [String]()

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var post: UILabel!
    @IBOutlet weak var optionOneBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var optionTwoBtn: UIButton!
    @IBOutlet weak var senderId: UILabel!
    let uid = Auth.auth().currentUser?.uid
    @IBAction func optionOneBtnPressed(_ sender: Any) {
        
        
        DataService.instance.setCellOptionOneCount(forContent: post.text!, foruid: senderId.text!) { (returned) in
            
        }
        DataService.instance.getCellKey(forContent: post.text!, foruid: senderId.text!) { (returnedCellKey) in
            DataService.instance.addUserToRatedUsers(withpost: self.post.text!, forCellUid: returnedCellKey, forUserUid: self.uid!) { (retuenUser) in
                
            }
        }
        DataService.instance.getCellOptionOneCount(forContent: post.text!, foruid: senderId.text!) { (returnedOptionOneCount) in
            DataService.instance.getCellOptionTwoCount(forContent: self.post.text!, foruid: self.senderId.text!, handler: { (returnedOptionTwoCount) in
                
                
                var optionOneRate = (Double)(100*(returnedOptionOneCount+1))/(Double)(returnedOptionOneCount+1+returnedOptionTwoCount)
                var optionTwoRate = 0.0
                if(returnedOptionTwoCount != 0){
                    optionTwoRate = (Double)(100*returnedOptionTwoCount)/(Double)(returnedOptionOneCount+1+returnedOptionTwoCount)
                    self.optionTwoBtn.setTitle("%\(Int(optionTwoRate))", for: UIControlState.normal)
                }else{
                    self.optionTwoBtn.setTitle("%\(0)", for: UIControlState.normal)
                }
                
                
                self.optionOneBtn.setTitle("%\(Int(optionOneRate))", for: UIControlState.normal)
                
            })
        }
    }
    @IBAction func optionTwoBtnPressed(_ sender: Any) {
        DataService.instance.setCellOptionTwoCount(forContent: post.text!, foruid: senderId.text!) { (returned) in
            
        }
        DataService.instance.getCellKey(forContent: post.text!, foruid: senderId.text!) { (returnedCellKey) in
            DataService.instance.addUserToRatedUsers(withpost: self.post.text!, forCellUid: returnedCellKey, forUserUid: self.uid!) { (retuenUser) in
                
            }
        }
        DataService.instance.getCellOptionOneCount(forContent: post.text!, foruid: senderId.text!) { (returnedOptionOneCount) in
            DataService.instance.getCellOptionTwoCount(forContent: self.post.text!, foruid: self.senderId.text!, handler: { (returnedOptionTwoCount) in
                
                
                var optionTwoRate = (Double)(100*(returnedOptionTwoCount+1))/(Double)(returnedOptionOneCount+1+returnedOptionTwoCount)
                
                var optionOneRate = 0.0
                
                if(returnedOptionOneCount != 0){
                    optionOneRate = (Double)(100*returnedOptionOneCount)/(Double)(returnedOptionOneCount+1+returnedOptionTwoCount)
                    self.optionOneBtn.setTitle("%\(Int(optionOneRate))", for: UIControlState.normal)
                }else{
                    self.optionOneBtn.setTitle("%\(0)", for: UIControlState.normal)
                }
                
                self.optionTwoBtn.setTitle("%\(Int(optionTwoRate))", for: UIControlState.normal)
                
                
            })
        }

    }
    
    
    
    @IBAction func followBtnPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
                if(followBtn.currentTitle == "Takip et"){
                        followBtn.setTitle("Takiptesin", for: .normal)
            
        }else{
            followBtn.setTitle("Takip et", for: .normal)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
