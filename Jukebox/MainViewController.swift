//
//  MainViewController.swift
//  test
//
//  Created by Philipp on 27.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded main")
        print(SPTAuth.defaultInstance().session)
        if SPTAuth.defaultInstance().session == nil {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "showLogin", sender: self)
            }
            
            /*DispatchQueue.main.async {
                self.present(SpotifyAuthViewController(), animated: true, completion: nil)
                
                //self.dismiss(animated: true, completion: nil)
            }*/
        }else {
            print(SPTAudioStreamingController.sharedInstance())
            print(SPTAuth.defaultInstance().session.isValid())
            print(SPTAuth.defaultInstance().session.tokenType)
            
            SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:track:58s6EuEYJdlb0kO7awm3Vp", startingWith: 0, startingWithPosition: 0, callback: { (error) in
                if (error != nil) {
                    print("playing!")
                }
            
            })
        }
        

        // Do any additional setup after loading the view.
    }

    @IBAction func Logout(_ sender: Any) {
        SPTAudioStreamingController.sharedInstance().logout()
        print(SPTAuth.defaultInstance().session)
        //SPTAudioStreamingController.sharedInstance().login(withAccessToken: session.accessToken)
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
