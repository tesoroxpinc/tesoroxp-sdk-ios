import Foundation

/// Defines the environment mode for the Tesoro SDK.
///
/// Use `.production` for live deployments and `.test` for integration testing.
public enum TesoroMode {
    /// Production environment pointing to the live Value Wall.
    case production

    /// Test environment for integration testing.
    case test

    /// The base URL for the Value Wall based on the current mode.
    var baseURL: URL {
        switch self {
        case .production:
            return URL(string: "https://valuewall.tesoroxp.com")!
        case .test:
            return URL(string: "https://test.valuewall.tesoroxp.com")!
        }
    }
}
