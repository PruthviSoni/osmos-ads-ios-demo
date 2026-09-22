import Foundation

enum AdError: LocalizedError {
    case sdkUnavailable
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .sdkUnavailable:
            return "Osmos SDK is unavailable."

        case .invalidResponse:
            return "Unable to load advertisements."
        }
    }
}
