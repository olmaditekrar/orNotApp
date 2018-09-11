//
//  feedVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 28.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class feedVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var feedTableView: UITableView!
    var feedArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.instance.getAllFeedMessages { (returnedFeedArray) in
        self.feedArray = returnedFeedArray.reversed()
        self.feedTableView.reloadData()
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCell") as? feedPostsCell else {
            return UITableViewCell()
        }
        
        let content = feedArray[indexPath.row]
        
       let uid = Auth.auth().currentUser?.uid
        cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.borderWidth = 5
        cell.senderId.text! = content.senderID
        cell.senderId.isHidden = true
        
        cell.post.text = content.post
        var ratedUser = "nothing"
        
        DataService.instance.getRatedUser(forContent: content.post, foruid:uid! , cellKey: content.senderID) { (returnedUser) in
            print(content.senderID)
            ratedUser = returnedUser
          
        }
        print(content.senderID)
        cell.optionOneBtn.setTitle("\(content.positiveStatus)", for: UIControlState.normal)
        cell.optionTwoBtn.setTitle("\(content.negativeStatus)", for: UIControlState.normal)
        //cell.optionOneBtn.setTitle("%\(content.optionOneRate)", for: UIControlState.normal)
        //cell.optionTwoBtn.setTitle("%\(content.optionTwoRate)", for: UIControlState.normal)
       
        DataService.instance.getLastName(forUid: content.senderID, handler: { (returnedLastName) in
            DataService.instance.getUserName(forUid: content.senderID) { (returnedName) in
                
                let name = returnedName + " " + returnedLastName
                cell.name.text = name
            }
            
        })
        

        

    
        
        return cell
    }
        
   

}
