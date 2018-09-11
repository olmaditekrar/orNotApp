//
//  settingsVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 1.03.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class settingsVC: UIViewController {

    @IBOutlet weak var editNameTextField: UITextField!
    

    @IBAction func cancelBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion:nil )
    }
    

    @IBAction func saveBtnPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        DataService.instance.setUserName(forUid: uid!, newUserName: editNameTextField.text!) { (status) in
            if(status){
                self.dismiss(animated: true, completion: nil)
            }else{
               print("error")
            }
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
        editNameTextField.delegate = self
        
        DataService.instance.getUserName(forUid:(Auth.auth().currentUser?.uid)!) { (returnedName) in
            self.editNameTextField.text = returnedName
        }
        
        // Do any additional setup after loading the view.
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension settingsVC :UITextFieldDelegate{
    
}
