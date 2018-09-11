//
//  AuthService.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 21.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    static let instance = AuthService()
    func registerUser(WithEmail email:String,AndPassword password:String,name: String,lastName:String,follower : [String], following :[String], userCreationComplete: @escaping(_ status: Bool, _ error :Error?) -> () )  {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else{
                userCreationComplete(false,error)
                return
            }
            
            let userData = ["provider" : user.providerID,"email":user.email, "UserName": name,"lastName" : lastName,"followers" : follower,"followings" : following] as [String : Any]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true,nil)
        }
        
    }
    func loginUser(WithEmail email:String,AndPassword password:String, loginComplete: @escaping(_ status: Bool, _ error :Error?) -> () )  {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false,error)
                return
            }
            
            loginComplete(true,nil)
        }
        
        
        
    }
    
   
   
    
    
}
