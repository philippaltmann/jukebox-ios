//
//  RegisterViewController.swift
//  test
//
//  Created by Philipp on 29.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegisterViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user:SPTUser?
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var welcomeText: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    // This constraint ties an element at zero points from the bottom layout guide
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //Set Vertical Center
        let dist:CGFloat = 214.0
        let diff:CGFloat = UIScreen.main.bounds.height/2 - dist
        self.keyboardHeightLayoutConstraint.constant = diff
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        name.delegate = self
        name.tag = 0
        email.delegate = self
        email.tag = 1
        password.delegate = self
        password.tag = 2
        
        if user != nil {
            if user?.displayName != nil{
                welcomeText.text = "Welcome to Jukebox, \(user?.displayName)!\nPlease complete your registration."
                name.text = user?.displayName
            }
            if (user?.largestImage) != nil{
                if let data = try? Data(contentsOf: (user?.largestImage.imageURL)!){
                    profilePicture.image = UIImage(data: data)
                }
            }
            //if user?.emailAddress != nil {
                email.text = user?.emailAddress ?? ""
            //}
        } else {print("Did not load user")}
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        name.resignFirstResponder()
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //TODO add icons to actions
        let alertController = UIAlertController(title: nil, message: "Edit your image.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertController.addAction(cancelAction)
        
        //Open camera roll to load new Picture
        let replaceAction = UIAlertAction(title: "Upload from Camera Roll", style: .default) { action in
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil) }
        alertController.addAction(replaceAction)
        
        //Replace Image with Default user Picture
        let removeAction = UIAlertAction(title: "Remove", style: .default) { action in
            let defaultPicture = UIImage.init(named: "ProfilePictureDefault")
            self.profilePicture.image = defaultPicture }
        alertController.addAction(removeAction)
        
        self.present(alertController, animated: true) { }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.profilePicture.image = chosenImage
        dismiss(animated: true, completion: nil)
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
            self.register(self)
        }
        // Do not add a line break
        return false
    }

    @IBAction func register(_ sender: Any) {
        print("register")
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
            // ...
            if(error?.localizedDescription != nil){
                let alertController = UIAlertController(title: "Unable to Register", message: error?.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { action in }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
                return
            }
            print("Registered?!")
            print(error?.localizedDescription ?? "Not Defined")
            print(user?.email ?? "Mail Not defined")
            
            Auth.auth().addStateDidChangeListener({ (auth:Auth, user:User?) in
                print(auth)
                print(user?.displayName)
            })
            //TODO create user reference in database 
            //Update Name
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = self.name.text
            //changeRequest?.photoURL =
            changeRequest?.commitChanges { (error) in
                // ...
                print("Welcome, \(user?.displayName)")
            }
            
            //let user:NSObject = {,"name": self.name.text}
            
            //Update Picture
            //self.uploadProfilePicture(userId: (user?.uid)!)
            
            /*
             
             @IBAction func dismissDialog(_ sender: Any) {
             print("dismissing")
             self.dismiss(animated: true, completion: nil)
             }*/
        }
    }
    
    func uploadProfilePicture(userId: String) -> Void {
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        let picture:Data = (UIImagePNGRepresentation(profilePicture.image!) as Data?)!
        
        // Create a storage reference from our storage service
        let profileRef = storage.reference().child("user").child(userId).child("profile.png")
        
        let uploadTask = profileRef.putData(picture, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type, and download URL.
            profileRef.downloadURL(completion: { (url:URL?, error:Error?) in
                print(url)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges { (error) in
                    let user = Auth.auth().currentUser
                    if let user = user {
                        print(user.photoURL)
                    }
                }
            })
        }
    }
    
    func displayErrorMessage(error: Error) {
        //Dispatch UI Error Alert
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
