//
//  createPostVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 22.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class createPostVC: UIViewController{

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var option2: UITextField!
    @IBOutlet weak var optionOne: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
         self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if textView.text != nil && textView.text != "Here where you will find your answer..." && option2.text != nil && optionOne.text != nil{
            saveButton.isEnabled = false
            DataService.instance.uploadPost(withpost: textView.text, andOptionOne: optionOne.text!, option2: option2.text!, forUid: (Auth.auth().currentUser?.uid)!, sendComplete: { (isComplete) in
                if isComplete{
                    self.saveButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                    
                }else{
                    self.saveButton.isEnabled = true
                    print("Something went wrong")
                    
                }
            })
            
            
        }
    }
    


}
extension createPostVC: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
         textView.text = ""
    }
    
    
}

