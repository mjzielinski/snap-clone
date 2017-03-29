//
//  ViewSnapViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/29/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import SDWebImage

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

 

}
