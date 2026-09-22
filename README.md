# Osmos Ads iOS Demo

A native SwiftUI iOS application demonstrating integration with the Osmos Ads SDK.

The application fetches banner advertisements, renders multiple ads in a scrollable view, tracks impressions when an ad becomes at least 50% visible, handles click tracking, opens destination URLs, and provides loading, empty, error, and retry states.

## Features

* Native SwiftUI iOS application
* Osmos iOS SDK integration
* Banner ad fetching
* Multiple banner ads in a scrollable view
* 50% visibility-based impression tracking
* One impression per ad
* SDK-based click tracking
* Destination URL handling
* Loading state
* Empty state
* Error handling
* Retry mechanism
* Duplicate request prevention
* Invalid/missing ad data handling

## Requirements

* macOS with Xcode
* iOS Simulator or physical iOS device
* Swift / SwiftUI
* Osmos iOS SDK

## Setup

1. Clone the repository.
2. Open `OsmosAdsDemo.xcodeproj` in Xcode.
3. Resolve the project's Swift Package Manager dependencies if required.
4. Select an iOS Simulator or physical iOS device.
5. Build and run the application.
6. Tap **Load Ads** to fetch advertisements.

## Osmos SDK Configuration

The Osmos SDK is initialized during application startup.

The demo uses the following configuration:

```text
Client ID: 10088010
Product Ads Host: demo.o-s.io
Display Ads Host: demo-ba.o-s.io
```

SDK initialization is handled in:

```text
App/AppDelegate.swift
```

## Ad Fetching

Ad fetching is handled by `OsmosAdService`.

The application requests display advertisements using:

```text
cliUbid: Any
pageType: demo_page
productCount: 10
adUnits: banner_ads
```

The service receives the SDK response, extracts the response data, decodes the JSON payload, and maps the banner ad information into the application's `DisplayAd` model.

The application uses information such as:

* Image URL
* Destination URL
* Impression tracking URL
* Click tracking URL
* UCLID
* Ad dimensions
* Ad position

Invalid advertisements that do not contain a valid image URL or UCLID are skipped safely.

## Impression Tracking

Impressions are fired when an advertisement becomes at least **50% visible** inside the application's visible container.

The implementation is located in:

```text
Ads/Visibility/AdVisibilityModifier.swift
```

A `GeometryReader` obtains the ad's frame in global coordinates.

The visible intersection between the ad frame and the container frame is calculated as:

```text
Visible Area / Ad Area
```

When the calculated visibility reaches or exceeds:

```text
0.5
```

the impression callback is triggered.

The tracking service then sends the impression event through the Osmos SDK.

Each ad is tracked only once using its `uclid`, preventing duplicate impression events when the user scrolls back and forth.

## Click Tracking

When a banner is tapped:

1. The application sends the click event through the Osmos SDK.
2. The destination URL is opened when one is available.

Click tracking is implemented in:

```text
Ads/Tracking/AdTrackingService.swift
```

The SDK method used for click tracking is:

```text
registerAdClickEvent
```

If an advertisement does not contain a destination URL, the application safely handles the situation without crashing.

## Architecture

The project follows a lightweight MVVM-oriented structure.

```text
App
│
├── OsmosAdsDemoApp
└── AppDelegate

Ads
│
├── API Repository
│   └── OsmosAdService
│
├── Models
│   ├── DisplayAd
│   └── OsmosAPIResponse
│
├── Tracking
│   └── AdTrackingService
│
├── ViewModels
│   └── AdsViewModel
│
├── Views
│   ├── AdsView
│   └── BannerAdView
│
└── Visibility
    └── AdVisibilityModifier

Core
└── AdError
```

### Responsibilities

**OsmosAdService**

Responsible for communicating with the Osmos SDK, fetching advertisements, decoding the response, and mapping the data into application models.

**OsmosAPIResponse**

Represents the decoded Osmos API response.

**DisplayAd**

Represents the application-level advertisement model used by the UI and tracking layer.

**AdsViewModel**

Coordinates ad loading, UI state, retry behavior, and tracking callbacks.

**BannerAdView**

Displays an individual banner advertisement and handles user interaction.

**AdVisibilityModifier**

Determines when an advertisement reaches the 50% visibility threshold.

**AdTrackingService**

Handles impression and click events through the Osmos SDK and prevents duplicate impressions.

## Application States

### Idle

Displayed before the user requests advertisements.

### Loading

Displayed while advertisements are being fetched.

### Loaded

Displays the available advertisements in a scrollable list.

### Empty

Displayed when the request succeeds but no advertisements are returned.

### Failed

Displayed when the ad request or response processing fails.

Both empty and failed states provide a **Retry** action.

## Error Handling

The application handles:

* SDK initialization failures
* SDK fetch failures
* Missing response data
* Invalid JSON
* Invalid image URLs
* Missing UCLIDs
* Missing destination URLs
* Empty ad responses
* Tracking failures

Invalid ad data is skipped where possible, while request-level failures are presented through the application's error state.

The application is designed to fail gracefully without crashing when advertisement data is incomplete or unavailable.

## Duplicate Request Prevention

The `AdsViewModel` prevents multiple simultaneous ad requests using an internal loading flag.

While a request is running:

* The Load Ads button is disabled.
* Additional calls to `loadAds()` are ignored.

This prevents duplicate requests while an existing request is in progress.

## Assumptions

* The assignment-provided Osmos client ID and demo hosts are used.
* `banner_ads` is the required ad unit.
* An ad impression is considered valid when at least 50% of the ad's area is visible within the application's visible container.
* Each advertisement should generate at most one impression event during its current loaded session.
* Advertisements without a valid image URL or UCLID are skipped.
* Destination URLs are optional and are only opened when available.
* The Osmos SDK is responsible for the actual impression and click event communication.

## Challenges

### SDK Response Parsing

The SDK returns the response through a nested dictionary structure with the actual JSON payload contained in the response data. The application extracts and decodes this payload into strongly typed Swift models.

### Variable Dimension Types

The ad response may represent width and height as either strings or numeric values. The response model handles both representations.

### 50% Visibility Tracking

SwiftUI does not provide a direct built-in callback for determining when a specific view reaches a 50% visibility threshold. A reusable `ViewModifier` was implemented using `GeometryReader` to calculate the visible intersection between the advertisement and its container.

### Duplicate Impressions

Scrolling can cause visibility callbacks to occur multiple times. Impression tracking therefore keeps track of already-fired UCLIDs to ensure each ad is only counted once.

## Running the Demo

1. Launch the application.
2. Tap **Load Ads**.
3. Wait for the banner advertisements to load.
4. Scroll through the advertisements.
5. Observe the Xcode console for impression events.
6. Tap an advertisement with a destination URL.
7. Observe the click tracking event and destination URL opening.
8. Test error and empty states using the available network/error scenarios.

## Demo Recording

The repository includes a short demo recording showing:

* Ad loading
* Banner rendering
* Impression tracking
* Scrolling and visibility detection
* Click tracking
* Destination URL handling
* Error handling and retry

## Logging

The application logs important ad lifecycle events in the Xcode console, including:

```text
[OSMOS] Ad Loaded
[OSMOS] Ad Failed
[OSMOS] Impression Fired
[OSMOS] Impression Response
[OSMOS] Click Fired
[OSMOS] Click Response
```

Successful SDK event responses can be verified through the Xcode console during the demo.

## License

This project was created as an iOS development assignment demonstrating Osmos Ads SDK integration.


## Demo Recording

[Watch the Osmos Ads Demo](https://drive.google.com/file/d/1DSI4-e_d64iBtF0596A_MFqe-6JaR3nL/view?usp=sharing)

The recording demonstrates:

* Ad loading
* Banner rendering
* Impression tracking
* Scrolling and visibility-based impressions
* Click tracking
* Destination URL handling
* Error and retry handling
