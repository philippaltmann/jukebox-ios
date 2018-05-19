//
//  PlaylistTableViewController.swift
//  Jukebox
//
//  Created by Maximilian Babel on 19.05.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func likedPlaylistComponent(_sender: UIButton){
        //Zugriff auf Firebase Datenbank
        //Inkrementieren des Counters für likes!
        
    }
}
