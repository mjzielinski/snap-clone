//
//  SelectUserViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/28/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var users : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        //* get list of users from the database
        FIRDatabase.database().reference().child("users").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            let user = User()
            user.email = (snapshot.value as! NSDictionary)["email"] as! String
            user.uid = snapshot.key
            
            self.users.append(user)
            
            self.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }

}
