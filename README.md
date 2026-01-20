# Tesoro SDK for iOS

The official Tesoro SDK for iOS enables you to integrate the Tesoro Value Wall into your iOS applications.

## Requirements

- iOS 14.0+
- Swift 5.9+
- Xcode 15.0+

## Installation

### Swift Package Manager (Recommended)

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/tesoroxpinc/tesoroxp-sdk-ios.git", from: "1.0.0")
]
```

Or in Xcode:
1. Go to **File → Add Package Dependencies...**
2. Enter: `https://github.com/tesoroxpinc/tesoroxp-sdk-ios.git`
3. Select your version requirements

### CocoaPods

Add to your `Podfile`:

```ruby
pod 'TesoroSDK', '~> 1.0'
```

Then run:

```bash
pod install
```

## Quick Start

```swift
import TesoroSDK

// Configure the SDK (typically in AppDelegate or app initialization)
Tesoro.configure(
    mode: .production,
    playerId: "your-player-id"
)

// Show the Value Wall
Tesoro.showValueWall()
```

## Configuration Options

```swift
// Configure with metadata
Tesoro.configure(
    mode: .production,
    playerId: "your-player-id",
    metadata: ["campaign": "summer2024", "source": "main_menu"]
)

// Customize the Value Wall appearance
let options = TesoroOptions(closeButtonColor: .white)
Tesoro.showValueWall(options: options)
```

## API Reference

### `Tesoro.configure(mode:playerId:metadata:)`

Initializes the SDK. Call this once at app startup.

| Parameter | Type | Description |
|-----------|------|-------------|
| `mode` | `TesoroMode` | `.production` or `.test` |
| `playerId` | `String` | Your unique player identifier |
| `metadata` | `[String: String]?` | Optional key-value pairs |

### `Tesoro.showValueWall(options:)`

Displays the Value Wall in a full-screen web view.

### `Tesoro.dismiss(animated:completion:)`

Programmatically closes the Value Wall.

## License

MIT License - see [LICENSE](LICENSE) for details.
