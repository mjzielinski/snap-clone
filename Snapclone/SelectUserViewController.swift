//
//  SelectUserViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/28/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //* outlet to tableView
    @IBOutlet weak var tableView: UITableView!
    
    //* create empty array of User objects
    var users : [User] = []
    
    //* create imageURL and snapDescription variables to accept values from PictureViewController
    var imageURL = ""
    var snapDescription = ""
    var uuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* set up table view
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

    //* specify number of rows based on number of User objects in array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //* populate the rows with user email addresses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
    
    //* when a row is selected, add the snap for that user
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        //* snap is a dictionary containing the from, description, imageURL, uuid
        let snap = ["from": FIRAuth.auth()!.currentUser!.email, "description": snapDescription, "imageURL": imageURL, "uuid": uuid]
        
        //* set the value from the snap dictionary
        FIRDatabase.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
        
        //** pop back to root
        navigationController!.popToRootViewController(animated: true)
    }

}
