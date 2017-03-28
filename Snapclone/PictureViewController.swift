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

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    //* set up imagePicker
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //* set up text field delegate
        descriptionTextField.delegate = self
        
        //* set up image picker delegate
        imagePicker.delegate = self
        
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
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        
        //* define source for image picker *** switch to .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        //* present another view controller on the screen for camera
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        nextButton.isEnabled = false
        
        let imagesFolder = FIRStorage.storage().reference().child("images")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        imagesFolder.child("\(NSUUID().uuidString).jpg").put(imageData, metadata: nil) { (metadata, error) in
            print("attempt upload image")
            if error != nil {
                print("Image upload error")
            } else {
                self.performSegue(withIdentifier: "selectUserSegue", sender: nil)
            }
        }
        
        
    }
    
    //* prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
}
