//
//  AppDelegate.swift
//  OsmosAdsDemo
//
//  Created by Pruthvi's Mac on 22/09/26.
//

import UIKit
import osmos

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        do{
            try OSMOS.Builder()
                .clientId("10088010")
                .debug(true)
                .productAdsHost("demo.o-s.io")
                .displayAdsHost("demo-ba.o-s.io")
                .buildGlobalInstance()
        } catch{
            print("Error initializing Osmos SDK: \(error)")
        }
        return true
    }
}
