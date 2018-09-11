//
//  DataService.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 6.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USER = DB_BASE.child("users")
    private var _REF_FEED = DB_BASE.child("feed")
    
    var REF_BASE:DatabaseReference{
        return _REF_BASE
    }
    var REF_USER:DatabaseReference{
        return _REF_USER
    }
    var REF_FEED:DatabaseReference{
        return _REF_FEED
    }
    
    func createDBUser(uid:String, userData:Dictionary<String, Any>) {
        REF_USER.child(uid).updateChildValues(userData)
    }
    func uploadPost(withpost post: String, andOptionOne Option1: String, option2: String, forUid uid:String, sendComplete: @escaping (_ status: Bool) -> ()){
         getUserName(forUid: uid) { (returnedName) in
            let ratedUsers = "";
            self.REF_FEED.childByAutoId().updateChildValues(["content":post,"option1":Option1,"option2":option2, "senderId": uid, "name" : returnedName ,"optionOneRate" : 0,"optionTwoRate" : 0,"ratedUsers" : ratedUsers])
        }
       
        sendComplete(true)
        
    }
    func addUserToRatedUsers(withpost post: String,forCellUid cell:String,forUserUid uid:String, sendComplete: @escaping (_ status: Bool) -> ()){
        print("burada")
        self.REF_FEED.child(cell).child("ratedUsers").childByAutoId().setValue(uid)
        sendComplete(true)
        
    }
    func getRatedUser(forContent content :String,foruid uid :String,cellKey: String, handler : @escaping(_ key :String) -> () ){
            //var returnedArray: [String] = []
            let ratedUserRef = self.REF_FEED.child(cellKey).child("ratedUsers")
            ratedUserRef.observeSingleEvent(of: .value) { (keySnapShot) in
                guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
                var ratedUser = ""
                for users in keySnapShot {
                    print(users)
                    let postuid = users.value as? String
                    
                      if(postuid == uid){
                        handler(uid)
                        
                        
                        
                      }else{
                        handler("")
                    }
                }
                
         }
        
      }



    

    
    
    func getUserName(forUid uid:String, handler : @escaping (_ userName :String) -> ()){
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for user in userSnapshot{
                if user.key == uid {
                    handler((user.childSnapshot(forPath: "UserName").value as? String)!)
                }
            }
        }
    }
    
    func setUserName(forUid uid:String, newUserName :String,handler : @escaping (_ status :Bool) -> ()){
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for user in userSnapshot{
                if user.key == uid {
                    self.REF_USER.child(uid).child("UserName").setValue(newUserName)
                    
                    handler(true)
                }
            }
        }
    }
    
    
    func getLastName(forUid uid:String, handler : @escaping (_ userName :String) -> ()){
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for user in userSnapshot{
                if user.key == uid {
                    handler((user.childSnapshot(forPath: "lastName").value as? String)!)
                }
            }
        }
    }
    func getFollowings(forUid uid:String, handler : @escaping (_ userName :[String]) -> ()){
        REF_USER.observeSingleEvent(of: .value) { (userSnapshot) in
            var followingsArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for user in userSnapshot{
                if user.key == uid {
                   let followings = user.childSnapshot(forPath: "following").value as? String
                    followingsArray.append(followings!)
                    handler(followingsArray)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    func updateRatings(withpost post: String, andOptionOne Option1: String, option2: String, forUid uid:String,sendComplete: @escaping (_ status: Bool) -> ()){
        
        REF_FEED.childByAutoId().updateChildValues(["content":post,"option1":Option1,"option2":option2, "senderId": uid])
        sendComplete(true)
        
    }
    
    
    
    func getAllFeedMessages(handler:@escaping (_ messages : [Category]) -> ()) {
        var FeedArray = [Category]()
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapShot) in
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else{
                return
            }
            for post in feedMessageSnapShot{
                let content = post.childSnapshot(forPath: "content").value as? String
                let option1 = post.childSnapshot(forPath: "option1").value as? String
                let option2 = post.childSnapshot(forPath: "option2").value as? String
                let senderId = post.childSnapshot(forPath: "senderId").value as? String
                let name = post.childSnapshot(forPath: "name").value as? String
                let optionOneCount = post.childSnapshot(forPath: "optionOneRate").value as? Int
                let optionTwoCount = post.childSnapshot(forPath: "optionTwoRate").value as? Int
                var optionOneRate = 0.0
                var optionTwoRate = 0.0
                
                if(optionOneCount != 0 || optionTwoCount != 0){
                    optionOneRate = (Double)(100*optionOneCount!)/(Double)(optionOneCount!+optionTwoCount!)
                    optionTwoRate = (Double)(100*optionTwoCount!)/(Double)(optionOneCount!+optionTwoCount!)
                    let roundedValue1 = NSString(format: "%.2f", optionOneRate)
                    let roundedValue2 = NSString(format: "%.2f", optionTwoRate)
                    let post = Category(negativeStatus: option1!, positiveStatus: option2!, colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: content!, optionTwoRate: Int(optionTwoRate), optionOneRate: Int(optionOneRate), userName: "userName", lastName: "LastName", senderID: senderId!)
                    FeedArray.append(post)
                }else{
                    let post = Category(negativeStatus: option1!, positiveStatus: option2!, colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: content!, optionTwoRate: Int(optionOneRate), optionOneRate: Int(optionOneRate), userName: "userName", lastName: "LastName", senderID: senderId!)
                    FeedArray.append(post)
                }

            }
            handler(FeedArray)
        }
        
    }
    
    func getOwnFeed(forUid uid:String, handler:@escaping (_ messages : [Category]) -> ()){
        var FeedArray = [Category]()
        REF_FEED.observeSingleEvent(of: .value) { (OwnfeedMessageSnapShot) in
            guard let OwnfeedMessageSnapShot = OwnfeedMessageSnapShot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for post in OwnfeedMessageSnapShot{
                let key = post.key
                let senderId = post.childSnapshot(forPath: "senderId").value as? String
                if senderId == uid {
                    let content = post.childSnapshot(forPath: "content").value as? String
                    let option1 = post.childSnapshot(forPath: "option1").value as? String
                    let option2 = post.childSnapshot(forPath: "option2").value as? String
                    let senderId = post.childSnapshot(forPath: "senderId").value as? String
                    let optionOneCount = post.childSnapshot(forPath: "optionOneRate").value as? Int
                    let optionTwoCount = post.childSnapshot(forPath: "optionTwoRate").value as? Int
                    var optionOneRate = 0.0
                    var optionTwoRate = 0.0
                   
                    if(optionOneCount != 0 || optionTwoCount != 0){
                        optionOneRate = (Double)(100*optionOneCount!)/(Double)(optionOneCount!+optionTwoCount!)
                        optionTwoRate = (Double)(100*optionTwoCount!)/(Double)(optionOneCount!+optionTwoCount!)
                        let roundedValue1 = NSString(format: "%.2f", optionOneRate)
                        let roundedValue2 = NSString(format: "%.2f", optionTwoRate)
                        let post = Category(negativeStatus: option1!, positiveStatus: option2!, colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: content!, optionTwoRate: Int(optionTwoRate), optionOneRate: Int(optionOneRate), userName: "userName", lastName: "LastName", senderID: senderId!)
                        FeedArray.append(post)
                    }else{
                        let post = Category(negativeStatus: option1!, positiveStatus: option2!, colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: content!, optionTwoRate: Int(optionOneRate), optionOneRate: Int(optionOneRate), userName: "userName", lastName: "LastName", senderID: senderId!)
                        FeedArray.append(post)
                    }
                  
                    
                   
                }
            }
            handler(FeedArray)

        }
    }
    
    func deleteFeed(forKey key: String){
        REF_FEED.child(key).removeValue()

    }
    


    func getCellKey(forContent content :String,foruid uid :String, handler : @escaping(_ key :String) -> () ){
        REF_FEED.observeSingleEvent(of: .value) { (keySnapShot) in
            guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
            var returnedkey = ""
            for post in keySnapShot {
                let postuid = post.childSnapshot(forPath: "senderId").value as? String
                let postContent = post.childSnapshot(forPath: "content").value as? String
                if(content.elementsEqual(postContent!) && postuid == uid ){
                    returnedkey = post.key
                }
                
            }
            handler(returnedkey)
            
        }
    }
    func getCellOptionOneCount(forContent content :String,foruid uid :String, handler : @escaping(_ key :Int) -> () ){
        REF_FEED.observeSingleEvent(of: .value) { (keySnapShot) in
            guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
            var returnedkey = 5
            for post in keySnapShot {
                let postuid = post.childSnapshot(forPath: "senderId").value as? String
                let postContent = post.childSnapshot(forPath: "content").value as? String
                if(content.elementsEqual(postContent!) && postuid == uid ){
                    let optionOneCount = post.childSnapshot(forPath: "optionOneRate").value as? Int
                    returnedkey = optionOneCount!
                }
                
            }
            handler(returnedkey)
            
        }
    }
    func setCellOptionOneCount(forContent content :String,foruid uid :String, handler : @escaping(_ key :Bool) -> () ){
        REF_FEED.observeSingleEvent(of: .value) { (keySnapShot) in
            guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
            
            self.getCellOptionOneCount(forContent: content, foruid: uid, handler: { (returnedCount) in
                for post in keySnapShot {
                    let postuid = post.childSnapshot(forPath: "senderId").value as? String
                    let postContent = post.childSnapshot(forPath: "content").value as? String
                    if(content.elementsEqual(postContent!) && postuid == uid ){
                        let newValue = returnedCount + 1
                        self._REF_FEED.child(post.key).child("optionOneRate").setValue(newValue)
                        
                    }

                    
                }
                
            })
            handler(true)
            
        }
    }

    func setCellOptionTwoCount(forContent content :String,foruid uid :String, handler : @escaping(_ key :Bool) -> () ){
        REF_FEED.observeSingleEvent(of: .value) { (keySnapShot) in
            guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
            
            self.getCellOptionTwoCount(forContent: content, foruid: uid, handler: { (returnedCount) in
                for post in keySnapShot {
                    let postuid = post.childSnapshot(forPath: "senderId").value as? String
                    let postContent = post.childSnapshot(forPath: "content").value as? String
                    if(content.elementsEqual(postContent!) && postuid == uid ){
                        let newValue = returnedCount + 1
                        self._REF_FEED.child(post.key).child("optionTwoRate").setValue(newValue)
                        
                    }
                    
                    
                }
                
            })
            handler(true)
            
        }
    }

    
    
    
    
    func getCellOptionTwoCount(forContent content :String,foruid uid :String, handler : @escaping(_ key :Int) -> () ){
        REF_FEED.observeSingleEvent(of: .value) { (keySnapShot) in
            guard let keySnapShot = keySnapShot.children.allObjects as? [DataSnapshot] else{return}
            var returnedkey = 5
            for post in keySnapShot {
                let postuid = post.childSnapshot(forPath: "senderId").value as? String
                let postContent = post.childSnapshot(forPath: "content").value as? String
                if(content.elementsEqual(postContent!) && postuid == uid ){
                    let optionOneCount = post.childSnapshot(forPath: "optionTwoRate").value as? Int
                    returnedkey = optionOneCount!
                }
                
            }
            handler(returnedkey)
            
        }
    }

    
    
    func SearchResult(search:String, handler:@escaping (_ messages : [Category]) -> ()){
        var FeedArray = [Category]()
        REF_FEED.observeSingleEvent(of: .value) { (OwnfeedMessageSnapShot) in
            guard let OwnfeedMessageSnapShot = OwnfeedMessageSnapShot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for post in OwnfeedMessageSnapShot{
                var content = post.childSnapshot(forPath: "content").value as? String
                content = content?.lowercased()
                var makeSearch = search.lowercased()
                if (content?.contains(makeSearch))! {
                    let content = post.childSnapshot(forPath: "content").value as? String
                    let option1 = post.childSnapshot(forPath: "option1").value as? String
                    let option2 = post.childSnapshot(forPath: "option2").value as? String
                    let senderId = post.childSnapshot(forPath: "senderId").value as? String
                    
                    let post = Category(negativeStatus: option1!, positiveStatus: option2!, colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: content!, optionTwoRate: 0, optionOneRate: 0, userName: "userName", lastName: "LastName", senderID: senderId!)
                    FeedArray.append(post)
                }
            }
            handler(FeedArray)
            
        }
    }
    func userSearchResult(search:String, handler:@escaping (_ messages : [Category]) -> ()){
        var FeedArray = [Category]()
        REF_USER.observeSingleEvent(of: .value) { (OwnfeedMessageSnapShot) in
            guard let OwnfeedMessageSnapShot = OwnfeedMessageSnapShot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for post in OwnfeedMessageSnapShot{
                var userName = post.childSnapshot(forPath: "UserName").value as? String
                var lastName = post.childSnapshot(forPath: "lastName").value as? String
                userName = userName?.lowercased()
                lastName = lastName?.lowercased()
                var makeSearch = search.lowercased()
                if ((userName?.contains(makeSearch))! || (lastName?.contains(makeSearch))!) {
                    
                    let returnedUserName = userName! + " " + lastName!
                    
                    
                    let post = Category(negativeStatus: "", positiveStatus: "", colone2name: "", colone1bame: "", negativeButtonname: "", positiveButtonname: "", post: returnedUserName, optionTwoRate: 0, optionOneRate: 0, userName: "", lastName: "", senderID: post.key)
                    FeedArray.append(post)
                }
            }
            handler(FeedArray)
            
        }
    }
    
    
    private let catagories = [
        
        
        Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv"),
         Category(negativeStatus: "kötü", positiveStatus: "iyi", colone2name: "whiteColone", colone1bame: "whiteColone", negativeButtonname: "Shape Copy", positiveButtonname: "Group Copt", post: "Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konuk Son 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10 yılda dünya çapında pek çok değerli yazar, düşünür, politikacı ve sanatçıyı konukSon 10k ", optionTwoRate: 0, optionOneRate: 0, userName: "bakacaz", lastName: "bakacaz", senderID: "vdfv")
      
    ]
    func getCategories() -> [Category] {
        return catagories
    }
    
}
