import Foundation
import osmos

final class AdTrackingService {

    private var trackedImpressions = Set<String>()

    func trackImpression(for ad: DisplayAd) {
        guard !trackedImpressions.contains(ad.uclid) else {
            return
        }

        trackedImpressions.insert(ad.uclid)

        print("[OSMOS] Impression Fired - \(ad.uclid)")

        do {
            let osmosManager = try OSMOS.shared()

            guard let registerEvent = osmosManager.registerEvent() else {
                print("[OSMOS] RegisterEvent unavailable")
                return
            }

            Task {
                let response = await registerEvent.registerAdImpressionEvent(
                    cliUbid: "Any",
                    uclid: ad.uclid,
                    position: ad.position,
                    trackingParams: nil,
                    onError: { error in
                        print(
                            "[OSMOS] Impression Failed - \(error.localizedDescription)"
                        )
                    }
                )

                print(
                    "[OSMOS] Impression Response - \(String(describing: response))"
                )
            }

        } catch {
            print("[OSMOS] Impression Tracking Error - \(error)")
        }
    }

    func trackClick(for ad: DisplayAd) {
        guard ad.destinationURL != nil else {
            print("[OSMOS] Click Failed - Destination URL unavailable")
            return
        }

        print("[OSMOS] Click Fired - \(ad.uclid)")

        do {
            let osmosManager = try OSMOS.shared()

            guard let registerEvent = osmosManager.registerEvent() else {
                print("[OSMOS] RegisterEvent unavailable")
                return
            }

            Task {
                let response = await registerEvent.registerAdClickEvent(
                    cliUbid: "Any",
                    uclid: ad.uclid,
                    trackingParams: nil,
                    onError: { error in
                        print(
                            "[OSMOS] Click Failed - \(error.localizedDescription)"
                        )
                    }
                )

                print(
                    "[OSMOS] Click Response - \(String(describing: response))"
                )
            }
        } catch {
            print("[OSMOS] Click Tracking Error - \(error)")
        }
    }
}
