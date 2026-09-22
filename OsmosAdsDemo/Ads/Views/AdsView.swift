import SwiftUI

struct AdsView: View {

    @StateObject private var viewModel = AdsViewModel(
        adService: OsmosAdService()
    )

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Text("Osmos Ads Demo")
                    .font(.title)
                    .fontWeight(.bold)

                Button {
                    Task {
                        await viewModel.loadAds()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Load Ads")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)

                content
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            }
            .padding()
            .navigationTitle("Osmos Ads")
        }
    }

    private var isLoading: Bool {
        if case .loading = viewModel.state {
            return true
        }

        return false
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {

        case .idle:
            Text("Tap Load Ads to fetch advertisements.")
                .foregroundStyle(.secondary)

        case .loading:
            ProgressView("Loading ads...")

        case .loaded:
            GeometryReader { container in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.ads) { ad in
                            BannerAdView(
                                ad: ad,
                                containerFrame: container.frame(in: .global),
                                onVisible: {
                                    viewModel.impression(for: ad)
                                },
                                onClick: {
                                    viewModel.click(for: ad)
                                }
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical)
                }
            }

        case .empty:
            retryView

        case .failed(let message):
            VStack(spacing: 10) {
                Text("Ad not available")

                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                retryButton
            }
        }
    }

    private var retryView: some View {
        VStack(spacing: 10) {
            Text("Ad not available")
            retryButton
        }
    }

    private var retryButton: some View {
        Button("Retry") {
            Task {
                await viewModel.loadAds()
            }
        }
    }
}
