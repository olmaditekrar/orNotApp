//
//  settingsVC.swift
//  orNotApp
//
//  Created by Halil İbrahim Şimşek on 1.03.2018.
//  Copyright © 2018 dotOrNotAppTeam. All rights reserved.
//

import UIKit

class settingsVC: UIViewController {

  
    @IBOutlet weak var settingsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getCategories().count-3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? feedPostsCell{
            let category = DataService.instance.getCategories()[indexPath.row]
            cell.UpdateViews(category: category)
            return cell
        }else{
            return feedPostsCell()
        }
    }

}
