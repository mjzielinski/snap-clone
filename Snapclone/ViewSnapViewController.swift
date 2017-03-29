//
//  ViewSnapViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/29/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
//* SDWebImage will convert URL to imageView
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ViewSnapViewController: UIViewController {
    
    //* outlet to imageView
    @IBOutlet weak var imageView: UIImageView!
    
    //* outlet to description Label
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //* set up snap object to receive data from SnapsViewController
    var snap = Snap()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* use snap URL to produce image for imageView
        imageView.sd_setImage(with: URL(string: snap.imageURL))
        //* use snapDescription for descriptionLabel
        descriptionLabel.text = snap.snapDescription
    }
    
    //* delete the snap after it has been viewed
    override func viewWillDisappear(_ animated: Bool) {
        
        //* remove snap from database by using the key value
        FIRDatabase.database().reference().child("users").child(FIRAuth.auth()!.currentUser!.uid).child("snaps").child(snap.key).removeValue()
        
        //* remove image from storage by using the snap uuid
            FIRStorage.storage().reference().child("images").child("\(snap.uuid).jpg").delete { (error) in
                if error == nil {
                    print("removed from storage")
                } else {
                    print(error!)
                }
        }
    }

}
