//
//  ViewController.swift
//  test
//
//  Created by Philipp on 25.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    var user:SPTUser?
    
    
    //Constraint for Moving keyboard
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Vertical Center
        let dist:CGFloat = 214.0
        let diff:CGFloat = UIScreen.main.bounds.height/2 - dist
        self.keyboardHeightLayoutConstraint.constant = diff
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        email.delegate = self
        email.tag = 1
        password.delegate = self
        password.tag = 2
        
        if user != nil{
            email.text = user?.emailAddress ?? ""
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let basePosition:CGFloat = 214.0
            let screenHeight:CGFloat = UIScreen.main.bounds.size.height
            let keyboardPosY:CGFloat = ((userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y)!
            let duration:TimeInterval = ((userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue)!
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: ((userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue)!)
            if keyboardPosY >= screenHeight {
                self.keyboardHeightLayoutConstraint?.constant = screenHeight / 2 - basePosition
            } else {
                self.keyboardHeightLayoutConstraint?.constant = screenHeight - keyboardPosY + 8.0
            }
            UIView.animate(withDuration: duration,delay: TimeInterval(0),options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
            self.login(self)
        }
        // Do not add a line break
        return false
    }
    
    /*@objc func keyboardNotification(notification: NSNotification) {
        let base:CGFloat = -96.0
        let dist:CGFloat = 172.0
        print(self.view.bounds.height)
        let diff:CGFloat = UIScreen.main.bounds.height/2 - dist
        print(diff)
        print(self.keyboardHeightLayoutConstraint.constant)
        //print(userInfo)
        print(UIScreen.main.bounds.height)
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            print(endFrameY)
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                
                self.keyboardHeightLayoutConstraint?.constant = 193.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 193.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }*/
    
    @IBAction func login(_ sender: Any) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(error?.localizedDescription != nil){
                print("error")
                let alertController = UIAlertController(title: "Login Failed", message: error?.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                print(user.uid)
                print(user.email)
                print(user.photoURL)
                print(user.displayName)
                self.dismiss(animated: true, completion: nil)
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

