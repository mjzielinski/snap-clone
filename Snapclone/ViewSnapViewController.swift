//
//  ViewSnapViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/29/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //* set up snap object to receive data
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.sd_setImage(with: URL(string: snap.imageURL))
        descriptionLabel.text = snap.snapDescription
    }
    
    //* delete the snap after it has been viewed
    override func viewWillDisappear(_ animated: Bool) {
        
            print("\(snap.key) 12345")
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.key).removeValue()
        
            print(snap.uuid)
            FIRStorage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
                if error == nil {
                    print("removed from storage")
                } else {
                    print(error)
                }
        }
    }
 

}
