//
//  ViewController.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class profileVC: UIViewController,UITableViewDataSource,UITableViewDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var popularityNum: UILabel!
    @IBOutlet weak var shape2: UIImageView!
    @IBOutlet weak var shape1: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
     let cellSpacingHeight: CGFloat = 5
    var isDeleted : Bool = false
    var feedArray = [Category]()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getOwnFeed(forUid: (Auth.auth().currentUser?.uid)!) { (returnedFeedArray) in
            self.feedArray = returnedFeedArray.reversed()
            self.tableView.reloadData()
        }
 
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {
        let logOutPopUp = UIAlertController(title: "Log Out?", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        let logOutAction = UIAlertAction(title: "Log Out?", style: .destructive) { (buttonTapped) in
            do{
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            }catch{
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        logOutPopUp.addAction(cancelAction)
        logOutPopUp.addAction(logOutAction)
        
        present(logOutPopUp, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        backgroundImage.layer.cornerRadius = 20
        backgroundImage.clipsToBounds = true
        backgroundImage.layer.borderColor = UIColor.clear.cgColor
        backgroundImage.layer.borderWidth = 4
        
        
        profileImage.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.choosePhoto))
        profileImage.addGestureRecognizer(recognizer)
        
 
        DataService.instance.getLastName(forUid: (Auth.auth().currentUser?.uid)!, handler: { (returnedLastName) in
            self.surname.text = returnedLastName
            
            
        })
        DataService.instance.getUserName(forUid: (Auth.auth().currentUser?.uid)!, handler: { (returnedUserName) in
            self.name.text = returnedUserName
            
        })

       
        
    }
    @objc func choosePhoto(){
        let picker  = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        profileImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        /*let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
         //self.isEditing = false
         print("more button tapped")
         }
         more.backgroundColor = UIColor.lightGray
         
         let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
         //self.isEditing = false
         print("favorite button tapped")
         }
         favorite.backgroundColor = UIColor.orange
         */
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            //self.isEditing = false
            print("share button tapped")
            
            let deletePopUp = UIAlertController(title: "delete?", message: "Are you sure you want to delete?", preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "delete?", style: .destructive) { (buttonTapped) in
                self.tableView.reloadData()
                let content = self.feedArray[indexPath.row]
                DataService.instance.getCellKey(forContent: content.post, foruid: (Auth.auth().currentUser?.uid)!) { (returnedUid) in
                    DataService.instance.deleteFeed(forKey: returnedUid)
                    print(returnedUid)
                    self.tableView.beginUpdates()
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.feedArray.remove(at: indexPath.row)
                    self.tableView.endUpdates()
                    
                    
                    
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            deletePopUp.addAction(cancelAction)
            deletePopUp.addAction(deleteAction)
            
            self.present(deletePopUp, animated: true, completion: nil)
            
            
            
            
            
            
        }
        delete.backgroundColor = UIColor.blue
        
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "categorycell") as? profilePostsCell else {
            return UITableViewCell()
        }
        
        let content = feedArray[indexPath.row]
        
        
        DataService.instance.getLastName(forUid: content.senderID, handler: { (returnedLastName) in
            DataService.instance.getUserName(forUid: content.senderID) { (returnedName) in
                
                let name = returnedName + " " + returnedLastName
                cell.name.text = name
            }
            
        })
        
       cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.layer.borderWidth = 5
        let uid = Auth.auth().currentUser?.uid
       
        cell.post.text = content.post
        cell.optionOne.setTitle("\(content.positiveStatus)", for: UIControlState.normal)
        cell.optionTwo.setTitle("\(content.negativeStatus)", for: UIControlState.normal)
        //cell.optionOne.setTitle("%\(content.optionOneRate)", for: UIControlState.normal)
        //cell.optionTwo.setTitle("%\(content.optionTwoRate)", for: UIControlState.normal)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

   
}



