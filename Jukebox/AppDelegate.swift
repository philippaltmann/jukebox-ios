//
//  AppDelegate.swift
//  test
//
//  Created by Philipp on 25.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var streamingDelegate: SPTAudioStreamingDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Setup Firebase
        FirebaseApp.configure()
        
        //Setup Spotify
        setupSpotify()
        
        return true
    }
    
    func setupSpotify() {
        //Shorthands
        let auth:SPTAuth! = SPTAuth.defaultInstance()
        let stream:SPTAudioStreamingController! = SPTAudioStreamingController.sharedInstance()
       
        
        //Configure Spotify ID, scope and keys + redirect, swap, refresh URLs
        auth.clientID = SpotifyConfig.clientID
        auth.redirectURL = SpotifyConfig.redirectURI
        auth.sessionUserDefaultsKey = SpotifyConfig.sessionKey
        auth.tokenRefreshURL = SpotifyConfig.refreshURL
        auth.tokenSwapURL = SpotifyConfig.swapURL
        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthUserLibraryReadScope, SPTAuthUserLibraryModifyScope, SPTAuthUserReadPrivateScope, SPTAuthUserReadTopScope, SPTAuthUserReadBirthDateScope, SPTAuthUserReadEmailScope]
        
        //Init and Set Streaming Delegate
        streamingDelegate = AudioStreamingDelegate()
        stream.delegate = streamingDelegate
        
        // Start the spotify player
        do {
            try stream.start(withClientId: SpotifyConfig.clientID)
        } catch { fatalError("Couldn't start Spotify SDK") }
        
        /*if let session = auth.session {
            if session.isValid(){
                stream.login(withAccessToken: session.accessToken)
            } else {
                auth.renewSession(auth.session) { (error, session) in
                    //Check if there is an error because then there won't be a session.
                    if let error = error {
                        print(error)
                        return
                    }
                    // Check if there is a session
                    if let session = session {
                        stream.login(withAccessToken: session.accessToken)
                    }
                }
            }
        }*/
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

