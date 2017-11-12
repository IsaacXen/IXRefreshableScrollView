# IXRefreshableScrollView

NSScrollView subclass with pull to refresh from top and pull to load from bottom.

## Installation

Drag `IXRefrashableScrollView.swift` to your project folder.

## Interface

```swift
protocol IXScrollViewRefreshable : class {

    /// The view to display when pulling from edge.
    func ixScrollView(_ scrollView: IXScrollView, viewForSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryView

    /// The Height of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, heightOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat

    /// The height of supplementary view to trigger.
    func ixScrollView(_ scrollView: IXScrollView, triggeredThresholdOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat

    /// Decided when should scroll view trigger the pulling action.
    func ixScrollView(_ scrollView: IXScrollView, triggerBehaviorOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryTriggerBehavior

    /// Callback to update supplementary view when pulling from edge.
    func ixScrollView(_ scrollView: IXScrollView, updateSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind, withProgress progress: CGFloat)

    /// Callback when pulling action has been triggered.
    /// Begin your custom supplementary view animation here.
    func ixScrollView(_ scrollView: IXScrollView, didTriggerSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind)

    /// Callback when pulling action is done or cancel.
    /// Stop your custom supplementary view animation here.
    func ixScrollView(_ scrollView: IXScrollView, didStopSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind)

}

extension IXScrollViewRefreshable where Self : RefreshableScrollView.IXScrollView {  
    func beginRefreshing()
    func stopRefreshing(scrollToTop: Bool = false)
    func beginLoading()
    func stopLoading(scrollToBottom: Bool = false)
}

class IXScrollView : NSScrollView, IXScrollViewRefreshable {

    enum SupplementaryElementKind {

        /// A kind of view to display when pulling from top.
        case refresh

        /// A kind of view to display when pulling from bottom.
        case load
    }

    enum SupplementaryTriggerBehavior {

        /// Scroll view is triggered as soon as it hit the trigger rect.
        case instant

        /// Scroll view is triggered if it's inside trigger rect when finger release.
        case overThreshold
    }

    /// The class scroll view to display when pulling from egde. This is used by default to show the progress indicator.
    /// Subclass this if you want to provide a custom one. Or you can provide a NSView subclass if you want.
    class SupplementaryView : NSView { ... }

    /// A bool value control whether scroll view is refreshable. `true` by default.
    var canPullToRefresh: Bool

    /// A bool value control whether scroll view is loadable. `false` by default.
    var canPullToLoad: Bool

    /// A bool value indicate whether scroll view is refreshing.
    var isRefreshing: Bool { get }

    /// A bool value indicate whether scroll view is loading.
    var isLoading: Bool { get }

    /// Perform Haptic Feedback when reach the trigger threshold. `true` by default.
    var triggeredWithHapticFeedback: Bool

    /// Pulling action to execute when triggered.
    var refreshAction: Selector?

    /// Pulling action to execute when triggered.
    var loadAction: Selector?

    /// The target to call action
    var target: AnyObject?
}
```

## Known Issues

- `SupplementaryTriggerBehavior.instant` doesn't work properly yet.
- Programmatically call `beginRefreshing()` or `beginLoading` won't scroll to edge.
- When `stopRefreshing` after a document height changed, scrolling twitch.
