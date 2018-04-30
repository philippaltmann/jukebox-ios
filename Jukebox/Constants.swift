//
//  Constants.swift
//  test
//
//  Created by Philipp on 25.04.18.
//  Copyright © 2018 Philipp. All rights reserved.
//

struct SpotifyConfig {
    static let clientID = "fee6107322b54ffe9accc4934b6b2b19"
    static let redirectURI = URL(string: "jkbx-auth://spotify")!
    static let sessionKey = "spotifySession"
    static let swapURL = URL(string: "https://jkbx-swapify.herokuapp.com/swap")
    static let refreshURL = URL(string: "https://jkbx-swapify.herokuapp.com/refresh")
}
