//
//  searchVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 4.08.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit
import Firebase
class searchVC: UIViewController {
    
    
    var SearchfeedArray = [Category]()
    var AllFeedArray = [Category]()
    var ArrayToShow = [Category]()
    var hasSearched = false
    var searchResults: [deneme] = []
    var userSearchResult : [Category] = []
    
    
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.rowHeight = 80
        
        self.hideKeyboardWhenTappedAround()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        
        self.searchTableView.rowHeight = 220
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // register nib
        
     
    }
    
    //text field has changed
    @objc func textFieldDidChange() {
        if(searchBar.text == ""){
            ArrayToShow = AllFeedArray
            searchTableView.reloadData()
            self.hasSearched = false
        }else{
            DataService.instance.userSearchResult(search: searchBar.text!, handler: { (returnedUsers) in
                self.ArrayToShow = returnedUsers
                self.searchTableView.reloadData()
                self.hasSearched = true
                
            })

           
 
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.instance.SearchResult(search: searchBar.text!) { (returnedSearchResult) in
            
            self.SearchfeedArray = returnedSearchResult.reversed()
            self.searchTableView.reloadData()
            
        }
        
        
     
        DataService.instance.getAllFeedMessages { (returnedFeedArray) in
            self.ArrayToShow = returnedFeedArray.reversed()
            self.AllFeedArray = returnedFeedArray.reversed()
            self.searchTableView.reloadData()
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
extension searchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("The search text is: '\(searchBar.text!)'")
        searchResults = []
        
        if(searchBar.text != ""){
            for i in 0...2 {
                let searchResult = deneme()
                searchResult.name = searchBar.text!
                
                searchResults.append(searchResult)
            }
        }
        
            
        
        hasSearched = true
        searchTableView.reloadData()
    }

   
}
extension searchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      /*  if !hasSearched {
            return AllFeedArray.count
        } else if SearchfeedArray.count == 0 {
            return 1
        } else {
            return SearchfeedArray.count
        }*/
        
           return ArrayToShow.count
            
        
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        

        if(!hasSearched){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as? searchResultCell else {
                return UITableViewCell()
            }
            
            let content = ArrayToShow[indexPath.row]
            
            cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.layer.borderWidth = 5
            cell.followBtn.isHidden = true
            tableView.rowHeight = 220
            cell.senderId.text! = content.senderID
            cell.senderId.isHidden = true
            
            cell.name.isHidden = false
            cell.optionOneBtn.isHidden = false
            cell.optionTwoBtn.isHidden = false
            let uid = Auth.auth().currentUser?.uid
            
            cell.post.text = content.post
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
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as? searchResultCell else {
                return UITableViewCell()
            }
            let content = ArrayToShow[indexPath.row]
            print(content.post)
        /*    DataService.instance.getLastName(forUid: content.senderID, handler: { (returnedLastName) in
                DataService.instance.getUserName(forUid: content.senderID) { (returnedName) in
                    
                    let name = returnedName + " " + returnedLastName
                    cell.post.text = name
                }
                
            })*/
            cell.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.layer.borderWidth = 5
            cell.followBtn.isHidden = false
            tableView.rowHeight = 110
            cell.post.text = content.post
            cell.senderId.text! = content.senderID
            cell.senderId.isHidden = true
            cell.name.isHidden = true
            cell.optionOneBtn.isHidden = true
            cell.optionTwoBtn.isHidden = true
           
      
            return cell
            
            /*  print("here")
            let cell = tableView.dequeueReusableCell(withIdentifier:
                "UserSearchResultCell", for: indexPath) as! userSearchResultCell
            
            print("yes")
           /* guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchResultCell") as? userSearchResultCell else {
                print("noo")
                return UITableViewCell()
                
            }*/
                print("yes")
            let content = userSearchResult[indexPath.row]
            let image : UIImage = UIImage(named: "688831351")!
            cell.name.text = content.name
            cell.userPhoto = UIImageView(image: image)
            
           self.searchTableView.reloadData()
            print(content.name + " ff")
            
            
            
            
            
            return cell
        */
            
        }

    }

    
}

extension searchVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}
extension searchVC :UITextFieldDelegate{
    
}
