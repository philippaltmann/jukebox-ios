//
//  ProfileViewController.swift
//  Jukebox
//
//  Created by Philipp on 09.05.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        do {try Auth.auth().signOut()}
        catch let signOutError as NSError {  print ("Error signing out: %@", signOutError) }
    }
    
    @IBAction func disconnectSpotify() -> Void {
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        let logoutAction = UIAlertAction(title: "Disconnect", style: .destructive) { action in
            SPTAudioStreamingController.sharedInstance().logout()
            SPTAuth.defaultInstance().session = nil
            UserDefaults.standard.removeObject(forKey: SpotifyConfig.sessionKey)
            //self.performSegue(withIdentifier: "showLogin", sender: self)
            //TODO notify logout
            self.dismiss(animated: true, completion: nil)
        }
            
        let alertController = UIAlertController(title: nil, message: "Do you really want to disconnect from Spotify ?", preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true)
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
