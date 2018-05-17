//
//  CreatePartyViewController.swift
//  Jukebox
//
//  Created by Philipp on 09.05.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit

class CreatePartyViewController: UIViewController {
    
    var playlists: [SPTPartialPlaylist] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Load Playlist Data For Fallback
        //TODO clean recursion 
        let user = SPTAuth.defaultInstance().session.canonicalUsername
        let accessToken = SPTAuth.defaultInstance().session.accessToken
        var callback:SPTRequestCallback = {(error, data) in
            if error != nil{ print(error); return }
            guard let playlists = data as? SPTPlaylistList else { print("Couldn't cast as SPTPlaylistList"); return }
            self.playlists = self.playlists + (playlists.items as? [SPTPartialPlaylist])!
            if playlists.hasNextPage {
                self.getNextPage(playlists: playlists)
            } else {
                print("Done loading Playlists")
                print(self.playlists)
            }
        }
        SPTPlaylistList.playlists(forUser: user, withAccessToken: accessToken, callback: callback)
    }

    func getNextPage(playlists: SPTListPage) -> Void {
        // Load Playlist Data
        let accessToken = SPTAuth.defaultInstance().session.accessToken
        let callback:SPTRequestCallback = {(error, data) in
            if error != nil{ print(error); return }
            guard let playlists = data as? SPTListPage else { print("Couldn't cast as SPTListPage"); return }
            self.playlists = self.playlists + (playlists.items as? [SPTPartialPlaylist])!
            if playlists.hasNextPage {
                self.getNextPage(playlists: playlists)
            } else {
                print("Done loading Playlists")
                print(self.playlists)
            }
        }
        playlists.requestNextPage(withAccessToken: accessToken, callback: callback)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
