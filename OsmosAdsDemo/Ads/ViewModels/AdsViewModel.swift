import Foundation
import Combine

@MainActor
final class AdsViewModel: ObservableObject {

    enum State {
        case idle
        case loading
        case loaded
        case empty
        case failed(String)
    }

    @Published private(set) var ads: [DisplayAd] = []
    @Published private(set) var state: State = .idle

    private let adService: AdService
    private let trackingService = AdTrackingService()

    private var isLoading = false

    init(adService: AdService) {
        self.adService = adService
    }

    func loadAds() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        state = .loading

        defer {
            isLoading = false
        }

        do {
            let result = try await adService.fetchAds()

            ads = result

            if result.isEmpty {
                state = .empty
                print("[OSMOS] Ad Failed - No ads returned")
            } else {
                state = .loaded
                print("[OSMOS] Ad Loaded - \(result.count) ads")
            }

        } catch {
            ads = []
            state = .failed(error.localizedDescription)

            print(
                "[OSMOS] Ad Failed - \(error.localizedDescription)"
            )
        }
    }

    func impression(for ad: DisplayAd) {
        trackingService.trackImpression(for: ad)
    }

    func click(for ad: DisplayAd) {
        trackingService.trackClick(for: ad)
    }
}
