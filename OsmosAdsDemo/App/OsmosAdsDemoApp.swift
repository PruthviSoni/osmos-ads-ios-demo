//
//  OsmosAdsDemoApp.swift
//  OsmosAdsDemo
//
//  Created by Pruthvi's Mac on 22/09/26.
//

import SwiftUI

@main
struct OsmosAdsDemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate

    var body: some Scene {
        WindowGroup {
            AdsView()
        }
    }
}
