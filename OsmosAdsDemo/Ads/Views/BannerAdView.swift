import SwiftUI

struct BannerAdView: View {

    let ad: DisplayAd
    let containerFrame: CGRect
    let onVisible: () -> Void
    let onClick: () -> Void

    @Environment(\.openURL) private var openURL

    var body: some View {
        AsyncImage(url: ad.imageURL) { phase in
            switch phase {

            case .empty:
                ProgressView()
                    .frame(height: 200)

            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()

            case .failure:
                Text("Ad not available")
                    .frame(height: 200)

            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onClick()

            if let destinationURL = ad.destinationURL {
                openURL(destinationURL)
            }
        }
        .adVisibility(
            threshold: 0.5,
            containerFrame: containerFrame,
            onVisible: onVisible
        )
    }
}
