//
//  feedVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 28.02.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class feedVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var feedTableView: UITableView!
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getCategories().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCell") as? feedPostsCell{
            let category = DataService.instance.getCategories()[indexPath.row]
            cell.UpdateViews(category: category)
            return cell
        }else{
            return feedPostsCell()
        }
    }
    
    
    
    
    
    

}
