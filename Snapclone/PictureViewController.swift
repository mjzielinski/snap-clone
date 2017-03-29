//
//  PictureViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/28/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import FirebaseStorage

class PictureViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //* outlet to imageView
    @IBOutlet weak var imageView: UIImageView!
    
    //* outlet to description textfield
    @IBOutlet weak var descriptionTextField: UITextField!
    
    //* outlet to next button
    @IBOutlet weak var nextButton: UIButton!
    
    //* set up imagePicker
    var imagePicker = UIImagePickerController()
    
    //* generate uuid
    var uuid = NSUUID().uuidString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* set up text field delegate
        descriptionTextField.delegate = self
        
        //* set up image picker delegate
        imagePicker.delegate = self
        
        //* make next button inactive
        nextButton.isEnabled = false
        
        //* to dismiss keyboard
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PictureViewController.dismissKeyboard)))
    }
    
    //* disappear the keyboard when click anywhere
    func dismissKeyboard() {
        descriptionTextField.resignFirstResponder()
    }
    
    //* disappear the keyboard when done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.descriptionTextField.resignFirstResponder()
        return true
    }

    //* take the camera image and assign to imageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        nextButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //* action for camera button tapped
    @IBAction func cameraTapped(_ sender: Any) {
        
        //* define source for image picker
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        //* present another view controller on the screen for camera
        present(imagePicker, animated: true, completion: nil)
    }

    //* action for next button tapped
    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        let imagesFolder = FIRStorage.storage().reference().child("images")
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        //* upload the image to Firebase storage
        imagesFolder.child("\(uuid).jpg").put(imageData, metadata: nil) { (metadata, error) in
            print("attempt upload image")
            if error != nil {
                print("Image upload error")
            } else {
                //* segue to SelectUserViewController, sending imageURL
                self.performSegue(withIdentifier: "selectUserSegue", sender: metadata?.downloadURL()!.absoluteString)
            }
        }
    }
    
    //* prepare for segue - here pass information to SelectUserViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! SelectUserViewController
        
        //* pick up imageURL from sender of performSegue
        nextVC.imageURL = sender as! String!
        //* pick up description from the textfield on this view controller
        nextVC.snapDescription = descriptionTextField.text!
        //* uuid for this snap
        nextVC.uuid = uuid
    }
}
