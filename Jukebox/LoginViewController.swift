//
//  ViewController.swift
//  test
//
//  Created by Philipp on 25.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Firebase Stuff
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func Register(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(error?.localizedDescription != nil){
                self.errorLabel.text = error?.localizedDescription
            }
            print("Registered?!")
            print(error?.localizedDescription ?? "Not Defined")
            print(user?.email ?? "Mail Not defined")
            
        }
    }
    
    @IBAction func Login(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(error?.localizedDescription != nil){
                self.errorLabel.text = error?.localizedDescription
            }
            print("Logged In?!")
            
            let user = Auth.auth().currentUser
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                print(user.uid)
                print(user.email)
                print(user.photoURL)
                print(user.displayName)
                // ...
            }
            //self.present(ViewController(), animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

