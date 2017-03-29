//
//  SignInViewController.swift
//  Snapclone
//
//  Created by Michael Zielinski on 3/27/17.
//  Copyright © 2017 Worldengine. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignInViewController: UIViewController {
    
    //* outlet to email text field
    @IBOutlet weak var emailTextField: UITextField!
    
    //* outlet to password text field
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //* action for Let's Go tapped
    @IBAction func letsGoTapped(_ sender: Any) {
        
        //* attempt sign in with provided email and password
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            print("Sign in attempt")
            
            //* if there was a sign in error, instead create a new user account with credentials
            if error != nil {
                print("Sign in error")
                
                //* create user account with credentials
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("attempt create user")
                    if error != nil {
                        print("create user error")
                    } else {
                        print("create user success")
                
                        //* add user to the database
                        FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email!)
                        
                        //* move to next ViewController
                        self.performSegue(withIdentifier: "signinSegue", sender: nil)
                    }
                })
            } else {
                //* if sign in successful move to next ViewController
                print("Sign in success")
                self.performSegue(withIdentifier: "signinSegue", sender: nil)
            }
            
        })
        
    }
    
    
}

