import UIKit
import WebKit

/// Internal view controller for presenting the Value Wall in a WKWebView.
final class TesoroWebViewController: UIViewController {

    // MARK: - Properties

    private let url: URL
    private let closeButtonColor: UIColor

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "xmark", withConfiguration: configuration)
        button.setImage(image, for: .normal)

        button.tintColor = closeButtonColor
        button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        button.layer.cornerRadius = 18
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.15
        button.layer.shadowRadius = 4

        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.accessibilityLabel = "Close"
        button.accessibilityHint = "Dismisses the Value Wall"

        return button
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    // MARK: - Initialization

    init(url: URL, closeButtonColor: UIColor = .label) {
        self.url = url
        self.closeButtonColor = closeButtonColor
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadURL()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(webView)
        view.addSubview(closeButton)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            // WebView fills the entire view
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Close button in top-right corner with safe area insets
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36),

            // Loading indicator in center
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func loadURL() {
        loadingIndicator.startAnimating()
        let request = URLRequest(url: url)
        webView.load(request)
    }

    // MARK: - Actions

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - WKNavigationDelegate

extension TesoroWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loadingIndicator.stopAnimating()
    }
}
