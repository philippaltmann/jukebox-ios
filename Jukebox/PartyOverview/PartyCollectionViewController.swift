//
//  PartyCollectionViewController.swift
//  Jukebox
//
//  Created by Philipp on 09.05.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"


class PartyCollectionViewController: UICollectionViewController {

    var ref: DatabaseReference!
    var hostParties:[NSDictionary] = []
    var guestParties:[NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Ready")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.ref = Database.database().reference()
        /*let sampleParty: NSDictionary = [
            "Name" : "Another Lit Party",
            "Host" : Auth.auth().currentUser?.uid,
            "Date" : "18.05.2018"
        ]
        self.ref.child("parties").childByAutoId().setValue(sampleParty)*/
        
        
        getParties()

        // Do any additional setup after loading the view.
    }
    
    func getParties() -> Void {
        
        let userID = Auth.auth().currentUser?.uid
        if userID == nil {
            return
        }
        
        ref.child("users/\(userID!)/parties").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let parties = snapshot.value as? NSDictionary
            //print(value)
            parties?.forEach({ (arg: (key: Any, value: Any)) in
                let (key, value) = arg
                self.ref.child("parties/\(key)").observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    switch value as! String{
                    case "host":
                        self.hostParties.append((snapshot.value as? NSDictionary)!)
                    default:
                        self.guestParties.append((snapshot.value as? NSDictionary)!)
                    }
                    self.collectionView?.reloadData()
                }) {(error) in print(error.localizedDescription)}
            })
        }) {(error) in print(error.localizedDescription)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("2 section")
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        switch section {
        case 0:
            return self.hostParties.count
        default:
            return self.guestParties.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PartyCollectionViewCell
        
        if indexPath.item >= hostParties.count{
            let index = indexPath.item - hostParties.count
            // Get Image from Firebase Store
            let imagePath = guestParties[index].object(forKey: "imagePath") as! String
            let imageReference = Storage.storage().reference(withPath: imagePath)
            imageReference.getData(maxSize: 1 * 512 * 512) { data, error in
                if let error = error {print(error)}
                else { cell.Image.image = UIImage(data: data!) }
            }
            cell.Label.text = guestParties[index].object(forKey: "Name") as! String
        } else {
            // Get Image from Firebase Store
            let imagePath = hostParties[indexPath.item].object(forKey: "imagePath") as! String
            let imageReference = Storage.storage().reference(withPath: imagePath)
            imageReference.getData(maxSize: 1 * 512 * 512) { data, error in
                if let error = error {print(error)}
                else { cell.Image.image = UIImage(data: data!) }
            }
            cell.Label.text = hostParties[indexPath.item].object(forKey: "Name") as! String
        }
        
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as? SectionHeader{
            switch indexPath.section{
            case 0:
                sectionHeader.Label.text = "Parties you Host"
                sectionHeader.Button.addTarget(self, action: #selector(self.createParty), for: .touchUpInside)
            default:
                sectionHeader.Label.text = "Parties you Attend"
                sectionHeader.Button.addTarget(self, action: #selector(self.joinParty), for: .touchUpInside)
            }
            //sectionHeader.Label.text = "Section \(indexPath.section)"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    @objc func createParty() -> Void{
        self.performSegue(withIdentifier: "createParty", sender: self)
    }
    
    @objc func joinParty() -> Void{
        self.performSegue(withIdentifier: "joinParty", sender: self)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
