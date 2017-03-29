//
//  SnapsViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/28/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //* outlet to tableView
    @IBOutlet weak var tableView: UITableView!
    
    //* make an array to hold Snap objects
    var snaps : [Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* set up tableView delegate and source
        tableView.dataSource = self
        tableView.delegate = self
        
        
            //* get list of snaps from the database and put into tableView
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            //* get details from snapshot and put into Snap object
            let snap = Snap()
            snap.imageURL = (snapshot.value as! NSDictionary)["imageURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.snapDescription = (snapshot.value as! NSDictionary)["description"] as! String
            snap.key = snapshot.key
            snap.uuid = (snapshot.value as! NSDictionary)["uuid"] as! String
            
            //* add Snap object to snaps array
            self.snaps.append(snap)
            self.tableView.reloadData()
            
        })
        
        //* removes the viewed snap from the tableview
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").observe(FIRDataEventType.childRemoved, with: { (snapshot) in
            
            var index = 0
            for snap in self.snaps {
                if snap.key == snapshot.key {
                    self.snaps.remove(at: index)
                }
                index += 1
            }
            self.tableView.reloadData()
            
        })
    }
    
    //* specify number of rows based on number of Snap objects in array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }
    
    //* populate the rows with from email addresses
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel!.text = "You have no snaps to view 🙁"
        } else {
            
            let user = snaps[indexPath.row]
            cell.textLabel?.text = user.from
            
        }
        return cell
    }
    
    //* when someone selects a snap segue to ViewSnapViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
        
    }
    
    //* prepare for segue, send Snap object to ViewSnapViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            let nextVC = segue.destination as! ViewSnapViewController
            nextVC.snap = sender as! Snap
        }
    }
    
    //* action for logout button
    @IBAction func logoutTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
