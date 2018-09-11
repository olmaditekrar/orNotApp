//
//  AuthVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 21.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {


    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        password.delegate = self
        email.delegate = self
    }
    


    @IBAction func signInButtonPressed(_ sender: Any) {
        if password.text != nil && email.text != nil{
            AuthService.instance.loginUser(WithEmail: email.text!, AndPassword: password.text!, loginComplete: { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print(String(describing : loginError?.localizedDescription))
                }
              
            })
        }
    }
   

}
extension AuthVC : UITextFieldDelegate{
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
