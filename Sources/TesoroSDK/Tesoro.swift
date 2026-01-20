import UIKit

/// The main entry point for the Tesoro SDK.
///
/// Use the `Tesoro` class to configure the SDK and present the Value Wall.
///
/// ## Overview
///
/// Configure the SDK once at app launch:
/// ```swift
/// Tesoro.configure(
///     mode: .production,
///     playerId: "player_123",
///     metadata: ["campaign": "summer2024"]
/// )
/// ```
///
/// Then present the Value Wall when needed:
/// ```swift
/// Tesoro.showValueWall()
/// ```
public final class Tesoro: NSObject {

    // MARK: - Shared Instance

    private static let shared = Tesoro()

    // MARK: - Configuration State

    private var mode: TesoroMode?
    private var playerId: String?
    private var metadata: [String: String]?
    private var isConfigured: Bool { mode != nil && playerId != nil }

    // MARK: - Presentation State

    private weak var currentWebViewController: TesoroWebViewController?

    // MARK: - Initialization

    private override init() {
        super.init()
    }

    // MARK: - Public API

    /// Configures the SDK with the specified mode, player ID, and optional metadata.
    ///
    /// Call this method once at app launch, typically in `application(_:didFinishLaunchingWithOptions:)`.
    ///
    /// - Parameters:
    ///   - mode: The environment mode (`.production` or `.test`).
    ///   - playerId: A unique identifier for the current player.
    ///   - metadata: Optional key-value pairs to pass to the Value Wall.
    public static func configure(
        mode: TesoroMode,
        playerId: String,
        metadata: [String: String]? = nil
    ) {
        shared.mode = mode
        shared.playerId = playerId
        shared.metadata = metadata
    }

    /// Presents the Value Wall in an embedded web view.
    ///
    /// The Value Wall is presented modally from the topmost view controller.
    /// Session state is persisted within the app across launches.
    ///
    /// - Parameter options: Presentation options for customizing appearance.
    /// - Returns: `true` if the Value Wall was presented, `false` otherwise.
    @discardableResult
    public static func showValueWall(options: TesoroOptions = TesoroOptions()) -> Bool {
        guard shared.isConfigured else {
            assertionFailure("Tesoro SDK is not configured. Call Tesoro.configure() first.")
            return false
        }

        guard let url = shared.buildURL() else {
            assertionFailure("Failed to build Value Wall URL.")
            return false
        }

        guard let viewController = shared.topViewController else {
            assertionFailure("Unable to find a view controller to present from.")
            return false
        }

        let closeButtonColor = options.closeButtonColor ?? .label
        let webViewController = TesoroWebViewController(url: url, closeButtonColor: closeButtonColor)

        shared.currentWebViewController = webViewController
        viewController.present(webViewController, animated: true)

        return true
    }

    /// Programmatically dismisses the Value Wall if it is currently presented.
    ///
    /// - Parameter animated: Whether to animate the dismissal. Defaults to `true`.
    /// - Parameter completion: A closure called after the dismissal completes.
    public static func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        shared.currentWebViewController?.dismiss(animated: animated, completion: completion)
        shared.currentWebViewController = nil
    }

    /// Returns `true` if the SDK has been configured.
    public static var isConfigured: Bool {
        shared.isConfigured
    }

    /// Returns the current mode, or `nil` if not configured.
    public static var currentMode: TesoroMode? {
        shared.mode
    }

    /// Resets the SDK configuration.
    ///
    /// This is primarily useful for testing. After calling this method,
    /// you must call `configure()` again before showing the Value Wall.
    public static func reset() {
        shared.mode = nil
        shared.playerId = nil
        shared.metadata = nil
        shared.currentWebViewController = nil
    }

    // MARK: - Internal Helpers

    private func buildURL() -> URL? {
        guard let mode = mode, let playerId = playerId else {
            return nil
        }

        var components = URLComponents(url: mode.baseURL, resolvingAgainstBaseURL: false)
        var queryItems = [URLQueryItem(name: "playerId", value: playerId)]

        if let metadata = metadata {
            for (key, value) in metadata.sorted(by: { $0.key < $1.key }) {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }

        components?.queryItems = queryItems
        return components?.url
    }

    private var topViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else {
            return nil
        }

        return findTopViewController(from: rootViewController)
    }

    private func findTopViewController(from viewController: UIViewController) -> UIViewController {
        if let presented = viewController.presentedViewController {
            return findTopViewController(from: presented)
        }

        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return findTopViewController(from: visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return findTopViewController(from: selectedViewController)
        }

        return viewController
    }
}
