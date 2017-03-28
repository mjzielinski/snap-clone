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

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func letsGoTapped(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            //* completion block
            print("Sign in attempt")
            if error != nil {
                print("Sign in error")
                //* create user account with credentials
                FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("attempt create user")
                    if error != nil {
                        print("create user error")
                    } else {
                        print("create user success")
                        self.performSegue(withIdentifier: "signinSegue", sender: nil)
                    }
                })
            } else {
                print("Sign in success")
                self.performSegue(withIdentifier: "signinSegue", sender: nil)
            }
            
        })
        
    }


}

