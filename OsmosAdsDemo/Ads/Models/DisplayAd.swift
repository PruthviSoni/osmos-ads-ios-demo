//
//  Untitled.swift
//  OsmosAdsDemo
//
//  Created by Pruthvi's Mac on 22/09/26.
//

import Foundation

struct DisplayAd: Identifiable {
    let id: String
    let imageURL: URL
    let destinationURL: URL?
    let impressionTrackingURL: String?
    let clickTrackingURL: String?
    let uclid: String
    let width: CGFloat
    let height: CGFloat
    let position: Int
}
