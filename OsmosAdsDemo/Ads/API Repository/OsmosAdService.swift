import Foundation
import osmos

protocol AdService {
    func fetchAds() async throws -> [DisplayAd]
}

final class OsmosAdService: AdService {

    func fetchAds() async throws -> [DisplayAd] {
        let osmos = try OSMOS.shared()

        guard let adFetcher = osmos.adFetcher() else {
            throw AdError.sdkUnavailable
        }

        let response = await adFetcher.fetchDisplayAdsWithAu(
            cliUbid: "Any",
            pageType: "demo_page",
            productCount: 10,
            adUnits: ["banner_ads"],
            targetingParams: nil,
            onError: { error in
                print("[OSMOS] Ad fetch failed:", error)
            }
        )

        guard let responseDictionary = response else {
            throw AdError.invalidResponse
        }

        guard let responseObject = responseDictionary["response"] as? [String: Any] else {
            throw AdError.invalidResponse
        }

        guard let dataString = responseObject["data"] as? String else {
            throw AdError.invalidResponse
        }

        guard let jsonData = dataString.data(using: .utf8) else {
            throw AdError.invalidResponse
        }

        let decoder = JSONDecoder()

        let apiResponse: OsmosAPIResponse

        do {
            apiResponse = try decoder.decode(
                OsmosAPIResponse.self,
                from: jsonData
            )
        } catch {
            print("[OSMOS] JSON decoding failed:", error)
            throw AdError.invalidResponse
        }

        guard let bannerAds = apiResponse.ads?.bannerAds else {
            return []
        }

        var displayAds: [DisplayAd] = []

        for (index, bannerAd) in bannerAds.enumerated() {

            guard
                let imageURLString = bannerAd.elements?.value,
                let imageURL = URL(string: imageURLString),
                let uclid = bannerAd.uclid
            else {
                print("[OSMOS] Skipping invalid ad at index \(index)")
                continue
            }

            let destinationURL: URL?

            if let destinationString = bannerAd.elements?.destinationURL {
                destinationURL = URL(string: destinationString)
            } else {
                destinationURL = nil
            }

            let width = CGFloat(
                Double(bannerAd.elements?.width ?? "0") ?? 0
            )

            let height = CGFloat(
                Double(bannerAd.elements?.height ?? "0") ?? 0
            )

            let ad = DisplayAd(
                id: uclid,
                imageURL: imageURL,
                destinationURL: destinationURL,
                impressionTrackingURL: bannerAd.impressionTrackingURL,
                clickTrackingURL: bannerAd.clickTrackingURL,
                uclid: uclid,
                width: width,
                height: height,
                position: index + 1
            )

            displayAds.append(ad)
        }

        return displayAds
    }
}
