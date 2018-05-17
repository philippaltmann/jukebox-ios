//
//  MainViewController.swift
//  test
//
//  Created by Philipp on 27.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if SPTAuth.defaultInstance().session == nil || Auth.auth().currentUser == nil{
            DispatchQueue.main.async { self.performSegue(withIdentifier: "showLogin", sender: self) }
        }
        // Do any additional setup after loading the view.
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
