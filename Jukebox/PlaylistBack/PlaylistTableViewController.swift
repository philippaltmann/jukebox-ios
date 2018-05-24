//
//  PlaylistTableViewController.swift
//  Jukebox
//
//  Created by Maximilian Babel on 19.05.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit

class PlaylistTableViewController: UITableViewController {
    
    @IBOutlet weak var playButton: UIButton?
    @IBOutlet weak var skipButton: UIButton?
    @IBOutlet weak var optionsButton: UIButton?
    @IBOutlet weak var searchButton: UIButton?

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
    
    @IBAction func showSongOptions(_sender: UIButton){
        
        //öffnen eines Optionsmenüs für die einzelen Songs z.B.: Like, Skip, show Interpret etc.
        
    }
    
    @IBAction func searchForTrack(_sender: UIButton){
        
        //öffnen eines Optionsmenüs für die einzelen Songs z.B.: Like, Skip, show Interpret etc.
        
    }
    
    
    
   // Search, Add, Play(only admin), Show number of votes, Delete(only admin), Skip(only admin), Statistics?(only admin)
}
