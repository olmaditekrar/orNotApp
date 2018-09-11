//
//  RegisterVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 26.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
         if password.text != nil && email.text != nil && name.text != nil && lastName.text != nil{
            AuthService.instance.registerUser(WithEmail: self.email.text!, AndPassword: self.password.text!, name: self.name.text!, lastName: self.lastName.text!, follower:["halil"], following:["ibrahim"], userCreationComplete: { (success, registerError) in
            if success{
                AuthService.instance.loginUser(WithEmail: self.email.text!, AndPassword: self.password.text!, loginComplete: { (success, nil) in
                    self.dismiss(animated: true, completion: nil)
                    print("registered user")
                })
            }else{
                print(String(describing : registerError?.localizedDescription))
            }
        })
    }
}
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
