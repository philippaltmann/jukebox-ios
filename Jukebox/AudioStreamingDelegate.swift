//
//  AudioStreamingDelegate.swift
//  test
//
//  Created by Philipp on 28.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

class AudioStreamingDelegate: NSObject,SPTAudioStreamingDelegate {
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        NotificationCenter.default.post(name: NSNotification.Name.Spotify.loggedIn, object: nil)
        
        print("Did Login")
        
        //spotify:track:6c6DEpGAvs1rzJkCp1ej8T
         SPTAudioStreamingController.sharedInstance().playSpotifyURI("spotify:track:2AKimSj4YSh5hdrPchltSI", startingWith: 0, startingWithPosition: 0, callback: { (error) in
         if error != nil{
         print("Playing")
         /*print(SPTAudioStreamingController.sharedInstance().metadata.currentTrack?.name)*/
         }
         })
         
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print("Did receive Error")
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveMessage message: String!) {
        print("Did receive Message")
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        print("Did Logout")
    }
    
    func audioStreamingDidEncounterTemporaryConnectionError(_ audioStreaming: SPTAudioStreamingController!) {
        print("Did encounter tmp Connection Error")
    }
    
    func audioStreamingDidDisconnect(_ audioStreaming: SPTAudioStreamingController!) {
        print("Did disconnect")
    }
    
    func audioStreamingDidReconnect(_ audioStreaming: SPTAudioStreamingController!) {
        print("Did Reconnect")
    }
}
