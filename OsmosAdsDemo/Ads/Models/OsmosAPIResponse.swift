//
//  Untitled.swift
//  OsmosAdsDemo
//
//  Created by Pruthvi's Mac on 22/09/26.
//

import Foundation

struct OsmosAPIResponse: Codable {
    let ads: OsmosAds?
}

struct OsmosAds: Codable {
    let bannerAds: [OsmosBannerAd]?
    
    enum CodingKeys: String, CodingKey {
        case bannerAds = "banner_ads"
    }
}

struct OsmosBannerAd: Codable {
    let au: String?
    let elements: OsmosElements?
    let clientId: Int?
    let crt: String?
    let rank: Int?
    let clickTrackingURL: String?
    let impressionTrackingURL: String?
    let uclid: String?
    
    enum CodingKeys: String, CodingKey {
        case au
        case elements
        case clientId = "client_id"
        case crt
        case rank
        case clickTrackingURL = "click_tracking_url"
        case impressionTrackingURL = "impression_tracking_url"
        case uclid
    }
}

struct OsmosElements: Codable {
    let type: String?
    let value: String?
    let destinationURL: String?
    let width: String?
    let height: String?
    
    enum CodingKeys: String, CodingKey {
        case type
        case value
        case destinationURL = "destination_url"
        case width
        case height
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decodeIfPresent(String.self, forKey: .type)
        value = try container.decodeIfPresent(String.self, forKey: .value)
        destinationURL = try container.decodeIfPresent(String.self, forKey: .destinationURL)
        
        // Osmos response has width/height as both numbers and strings.
        if let value = try? container.decode(String.self, forKey: .width) {
            width = value
        } else if let value = try? container.decode(Double.self, forKey: .width) {
            width = String(value)
        } else if let value = try? container.decode(Int.self, forKey: .width) {
            width = String(value)
        } else {
            width = nil
        }
        
        if let value = try? container.decode(String.self, forKey: .height) {
            height = value
        } else if let value = try? container.decode(Double.self, forKey: .height) {
            height = String(value)
        } else if let value = try? container.decode(Int.self, forKey: .height) {
            height = String(value)
        } else {
            height = nil
        }
    }
}
