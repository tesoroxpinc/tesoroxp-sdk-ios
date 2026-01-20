import UIKit

/// Presentation options for the Value Wall.
///
/// Use these options to customize the appearance of the Value Wall
/// when presented via `Tesoro.showValueWall(options:)`.
public struct TesoroOptions {
    /// Custom color for the close button.
    /// If `nil`, the system label color is used.
    public var closeButtonColor: UIColor?

    /// Creates a new `TesoroOptions` instance.
    ///
    /// - Parameters:
    ///   - closeButtonColor: Custom close button color. Defaults to `nil` (system label color).
    public init(closeButtonColor: UIColor? = nil) {
        self.closeButtonColor = closeButtonColor
    }
}
