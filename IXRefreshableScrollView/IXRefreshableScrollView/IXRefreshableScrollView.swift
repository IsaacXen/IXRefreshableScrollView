//
// Version 0.0.3
//
//  MIT License
//
//  Copyright (c) 2017 ix4n33
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Cocoa

// MARK: - Protocols

protocol IXScrollViewRefreshable: class {
    
    /// The view to display when pulling from edge.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view that require the supplementary view.
    ///   - kind: A enum indicate the kind of supplementary view.
    /// - Returns: The supplementary view should be display on the edge.
    func ixScrollView(_ scrollView: IXScrollView, viewForSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryView
    
    /// The Height of supplementary view.
    /// Override this if you have a custom supplementary view that need a different height. This return 40 by default.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view that require the supplementary view height.
    ///   - kind: A enum indicate the kind of supplementary view.
    /// - Returns: The height of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, heightOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat
    
    ///
    /// / Depercated /
    ///
    /// The height of supplementary view to trigger.
    /// This is use to trigger pulling action when pulling this far.
    /// By default, this return the value of ixScrollView(_: heightOfSupplementaryElementOfKind:) plus 10.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view that require the supplementary view trigger threshold.
    ///   - kind: A enum indicate the kind of supplementary view.
    /// - Returns: The trigger threshold of supplementary view.
//    func ixScrollView(_ scrollView: IXScrollView, triggeredThresholdOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat
    
    /// Decided when should scroll view trigger the pulling action.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view that require the supplementary view trigger behavior.
    ///   - kind: A enum indicate the kind of supplementary view.
    /// - Returns: The kind of behavior to trigger pulling action.
    func ixScrollView(_ scrollView: IXScrollView, triggerBehaviorOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryTriggerBehavior
    
    /// Callback to update supplementary view when pulling from edge.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view target.
    ///   - supplementaryView: The supplementary view that need to update.
    ///   - kind: A enum indicate the kind of supplementary view.
    ///   - progress: A Float value from 0 to 1 indicate how far is pull from origin position to trigger threshold height. this can go beyond 1 if pull over threshold. Just in case if you want to add more animation when pulling over.
    func ixScrollView(_ scrollView: IXScrollView, updateSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind, withProgress progress: CGFloat)
    
    /// Callback when pulling action has been triggered.
    /// Begin your custom supplementary view animation here.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view target.
    ///   - supplementaryView: The supplementary view that triggered.
    ///   - kind: A enum indicate the kind of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, didTriggerSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind)
    
    
    /// Callback when pulling action is done or cancel.
    /// Stop your custom supplementary view animation here.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view target.
    ///   - supplementaryView: The supplementary view that triggered.
    ///   - kind: A enum indicate the kind of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, didStopSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind)
}

// MARK: - Default protocol confirmation

extension IXScrollViewRefreshable {
    
    func ixScrollView(_ scrollView: IXScrollView, viewForSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryView {
        if kind == .refresh {
            if scrollView.supplementalRefreshView == nil {
                let view = IXScrollView.SupplementaryView(withIndicator: true)
                view.frame = NSMakeRect(0, -scrollView.supplementalRefreshViewHeight, scrollView.frame.width, scrollView.supplementalRefreshViewHeight)
                return view
            }
            return scrollView.supplementalRefreshView!
        } else {
            if scrollView.supplementalLoadingView == nil {
                let view = IXScrollView.SupplementaryView(withIndicator: true)
                view.frame = NSMakeRect(0, scrollView.frame.height, scrollView.frame.width, scrollView.supplementalLoadingViewHeight)
                return view
            }
            return scrollView.supplementalLoadingView!
        }
    }
    
    func ixScrollView(_ scrollView: IXScrollView, heightOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat {
        return 40
    }
    
    // / Depercated /
//    func ixScrollView(_ scrollView: IXScrollView, triggeredThresholdOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat {
//        return ixScrollView(scrollView, heightOfSupplementaryElementOfKind: kind) + 10
//    }
    
    func ixScrollView(_ scrollView: IXScrollView, updateSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind, withProgress progress: CGFloat) {
//        print("update with progress: \(progress)")
        if !scrollView._isRefreshing || !scrollView._isLoading {
            supplementaryView.indicator.doubleValue = Double(progress * 100)
            supplementaryView.indicator.alphaValue = progress
        }
    }
    
    func ixScrollView(_ scrollView: IXScrollView, triggerBehaviorOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> IXScrollView.SupplementaryTriggerBehavior {
        return IXScrollView.SupplementaryTriggerBehavior.overThreshold
    }
    
    func ixScrollView(_ scrollView: IXScrollView, didTriggerSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind) {
        supplementaryView.indicator.isIndeterminate = true
        supplementaryView.indicator.startAnimation(self)
    }
    
    func ixScrollView(_ scrollView: IXScrollView, didStopSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind) {
        supplementaryView.indicator.stopAnimation(self)
        supplementaryView.indicator.isIndeterminate = false
    }

}


// MARK: - Extra function for protocol


extension IXScrollViewRefreshable where Self: IXScrollView {
    
    private func scrollToTop(_ completion: (() -> Void)?) {
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.timingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
            contentView.animator().setBoundsOrigin(NSMakePoint(0, -supplementalRefreshViewHeight))
        }, completionHandler: completion)

    }
    
    private func scrollToBottom() {
        
    }
    
    private func scrollToCurrentPointIfPossible() {
        
    }
    
    func beginRefreshing(scrollToTop shouldScrollToTop: Bool = false) {
        if _isRefreshing { return }
        _isRefreshing = true
        
        oldDocumentHeight = documentHeight
        
        if shouldScrollToTop {
            scrollToTop {
                self.ixScrollView(self, didTriggerSupplementaryElement: self.supplementalRefreshView!, ofKind: .refresh)
                self.performAction(for: .refresh)
            }
        } else {
            ixScrollView(self, didTriggerSupplementaryElement: supplementalRefreshView!, ofKind: .refresh)
            performAction(for: .refresh)
        }
    }
    
    func stopRefreshing(scrollToTop shouldScrollToTop: Bool = false) {
        
        // TODO: FIX ME!
        // if set _isRefreshing early, scrolling after animation stop will be normal, but animation will be broken.
        // if set _isRefreshing in completion, animation will be normal, but scrolling will be broken.
        // it's all about clipview's document height.
        // if can find a way to manually update it, this may be fixed.
        // so the question here is how.
        
        if visibleY <= 0 {
            if !shouldScrollToTop {
                if oldVisibleY <= 0 {
                    let reversedY = documentHeight - oldDocumentHeight + visibleY
                    if abs(oldVisibleY) < abs(reversedY) {
                        self._isRefreshing = false
                    }
                }
            }
        }
        
        NSAnimationContext.runAnimationGroup({ _ in
            if visibleY <= 0 {
                if shouldScrollToTop {
                    scrollToTop(nil)
                } else {
                    if oldVisibleY <= 0 {
                        let reversedY = documentHeight - oldDocumentHeight + visibleY
                        
                        if abs(oldVisibleY) < abs(reversedY) {
                            let newOrigin = NSMakePoint(0, reversedY)
                            contentView.setBoundsOrigin(newOrigin)
                        } else {
                            contentView.animator().setBoundsOrigin(.zero)
                        }
                    }
                }
            }
        }) {
            self._isRefreshing = false
            self.ixScrollView(self, didStopSupplementaryElement: self.supplementalRefreshView!, ofKind: .refresh)
        }
        
    }
    
    func beginLoading() {
        if _isLoading { return }
        _isLoading = true
        
        ixScrollView(self, didTriggerSupplementaryElement: supplementalLoadingView!, ofKind: .load)
        performAction(for: .load)
    }
    
    func stopLoading(scrollToBottom shouldScrollToBottom: Bool = false) {
        let y = self.documentVisibleRect.origin.y
        let h = self.documentVisibleRect.size.height
        let dh = self.documentView?.frame.size.height ?? h
        
        NSAnimationContext.runAnimationGroup({ _ in
            if y > h { contentView.animator().setBoundsOrigin(NSMakePoint(0, dh - h)) }
        }) {
            self._isLoading = false
            self.ixScrollView(self, didStopSupplementaryElement: self.supplementalLoadingView!, ofKind: .load)
        }
    }
    
    private func performAction(for kind: SupplementaryElementKind) {
        guard let target = target else {
            print("IXScrollView: can not perform action: target is nil!")
            return
        }
        
        if kind == .refresh {
            if let action = refreshAction { _ = target.perform(action) }
        } else {
            if let action = loadAction { _ = target.perform(action) }
        }
        
    }
}

// MARK: -

class IXScrollView: NSScrollView, IXScrollViewRefreshable {
    
    // MARK: Internal Class & Enum
    
    // A enum indicate the kind of supplementary view.
    enum SupplementaryElementKind {
        
        /// A kind of view to display when pulling from top.
        case refresh
        
        /// A kind of view to display when pulling from bottom.
        case load
    }
    
    // A set of behavior of how scroll view should be triggered when pulling from the edge.
    enum SupplementaryTriggerBehavior {
        
        /// Scroll view is triggered as soon as it hit the trigger rect.
        case instant
        
        /// Scroll view is triggered if it's inside trigger rect when finger release.
        case overThreshold
    }
    
    /// The class scroll view to display when pulling from egde. This is used by default to show the progress indicator.
    /// Subclass this if you want to provide a custom one. Or you can provide a NSView subclass if you want.
    class SupplementaryView: NSView {
        
        /// The indicator to show the current status.
        lazy var indicator: NSProgressIndicator = {
            let indicator = NSProgressIndicator()
            indicator.frame = NSMakeRect(0, 0, 20, 20)
            indicator.isDisplayedWhenStopped = true
            indicator.isIndeterminate = false
            indicator.style = .spinning
            indicator.maxValue = 100
            indicator.minValue = 0
            indicator.doubleValue = 0
            indicator.translatesAutoresizingMaskIntoConstraints = false
            return indicator
        }()
        
        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
        }
        
        required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)
        }
        
        init(withIndicator createIndicator: Bool) {
            super.init(frame: .zero)
            if createIndicator {
                setupSupplementaryView()
            }
        }
        
        /// Setup indicator if needed. This is call only when you using init(withIndicator:) and set it to true.
        /// Which mean, if you want to create you own supplementary view, you can set it to false.
        func setupSupplementaryView() {
            addSubview(indicator)

            addConstraint(indicator, .centerX, .equal, to: self, .centerX)
            addConstraint(indicator, .centerY, .equal, to: self, .centerY)
            addConstraint(indicator, .height, .equal, to: nil, .height, plus: 20)
            addConstraint(indicator, .width, .equal, to: nil, .width, plus: 20)
        }
    }
    
    
    // MARK: - Public Properties
    
    
    /// A bool value control whether scroll view is refreshable.
    var canPullToRefresh = true {
        didSet { updateStoredSupplementaryElement(ofKind: .refresh, by: canPullToRefresh) }
    }
    
    /// A bool value control whether scroll view is loadable.
    var canPullToLoad = false {
        didSet { updateStoredSupplementaryElement(ofKind: .load, by: canPullToLoad) }
    }

    /// A bool value indicate whether scroll view is refreshing.
    var isRefreshing: Bool { return _isRefreshing }
    
    /// A bool value indicate whether scroll view is loading.
    var isLoading: Bool { return _isLoading }
    
    /// Perform Haptic Feedback when reach the trigger threshold.
    var triggeredWithHapticFeedback = true
    
    // Target & Actions
    var target: AnyObject?
    var refreshAction: Selector?
    var loadAction: Selector?
    
    
    // MARK: - Private Properties
    
    
    /// The delegate of IXScrollViewRefreshable.
    fileprivate lazy var refreshableDelegate: IXScrollViewRefreshable = self
    
    /// Height of refresh view.
    fileprivate var supplementalRefreshViewHeight: CGFloat = 0
    
    // / Depercated /
    /// Trigger height of refresh view.
//    fileprivate var supplementalRefreshViewTriggeredHeight: CGFloat = 0
    
    /// This control how scroll view should be trigger when pull from top. See SupplementaryTriggerBehavior for more info about different behavior.
    fileprivate var supplementalRefreshViewTriggerBehavior: SupplementaryTriggerBehavior = .overThreshold
    
    /// The view to display when pull from top.
    fileprivate var supplementalRefreshView: SupplementaryView? {
        didSet {
            // add view to scroll view with constraints.
            placeSupplementalElement(supplementalRefreshView, ofKindToContentViewIfNeeded: .refresh)
        }
    }

    /// height of loading view.
    fileprivate var supplementalLoadingViewHeight: CGFloat = 0
    
    // / Depercated /
    /// Trigger height of loading view.
//    fileprivate var supplementalLoadingViewTriggeredHeight: CGFloat = 0
    
    /// This control how scroll view should be trigger when pull from bottom. See SupplementaryTriggerBehavior for more info about different behavior.
    fileprivate var supplementalLoadingViewTriggerBehavior: SupplementaryTriggerBehavior = .overThreshold
    
    /// The view to display when pull from bottom.
    fileprivate var supplementalLoadingView: SupplementaryView? {
        didSet {
            // add view to scroll view with constraints.
            placeSupplementalElement(supplementalLoadingView, ofKindToContentViewIfNeeded: .load)
        }
    }
    
    fileprivate var _progress: CGFloat = 0 {
        willSet {
            lastProgress = _progress
        }
        
        didSet {
            // ask delegate to update
            if _progress >=  1 { refreshableDelegate.ixScrollView(self, updateSupplementaryElement: supplementalRefreshView!, ofKind: .refresh, withProgress: progress) }
            if _progress <= -1 { refreshableDelegate.ixScrollView(self, updateSupplementaryElement: supplementalLoadingView!, ofKind: .load, withProgress: -progress) }
            
            // perform Haptic Feedback if needed
            performHapticFeedbackIfNeeded()
        }
    }
    
    fileprivate var progress: CGFloat {
        get {
            return _progress + (_progress > 0 ? -1 : 1)
        }
        
        set {
            _progress = newValue + (newValue >= 0 ? 1 : -1)
//            print(lastProgress, newValue)
        }
    }
    
    /// A Float value storing last progress value.
    fileprivate var lastProgress: CGFloat = 0
    
    
    // MARK: - Init
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupSupplementalViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSupplementalViews()
    }
    
    // Setup supplemental views if needed.
    private func setupSupplementalViews() {
        
        askDelegateForSupplementalRefreshViewIfNeeded()
        askDelegateForSupplementalLoadingViewIfNeeded()
        
        observeBoundsChangedNotificationsIfNeeded()
        
        scroll(NSMakePoint(contentView.frame.origin.x, 0))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: contentView)
    }
    
    
    // MARK: - Overrides
    
    
    /// Change default clip view to custom one.
    override var contentView: NSClipView {
        get {
            var superClipView = super.contentView

            // if the clip view is not our custom one...
            if !superClipView.isKind(of: IXClipView.self), let documentView = superClipView.documentView {
                
                // create our custom clip view
                let clipView = IXClipView(original: superClipView)
                clipView.frame = superClipView.frame
                clipView.documentView = documentView

                // then set it as the clipview to use
                self.contentView = clipView

                superClipView = clipView
            }
            
            return superClipView
        }
        
        set {
            super.contentView = newValue
        }
    }

    // TODO: Maybe an option to allow one action at a time?
    /// Hijack scroll wheel event to trigger action when finger leave
    override func scrollWheel(with event: NSEvent) {
        
        // when finger leave trackpad...
        if event.phase == .ended {
            if canPullToRefresh && !_isRefreshing {
                stopReceivingBoundsChanged = false
                
                if supplementalRefreshViewTriggerBehavior == .overThreshold && _progress >= 2 {
                    beginRefreshing()
                }
            }
            
            if canPullToLoad && !_isLoading {
                stopReceivingBoundsChanged = false
                
                if supplementalLoadingViewTriggerBehavior == .overThreshold && _progress <= -2 {
                    beginLoading()
                }
            }
        }

        super.scrollWheel(with: event)
    }
    
    
    // MARK: - Callbacks
    
    
    /// A bool indicate whether scroll view once pass the trigger rect.
    fileprivate var didTriggered: Bool = false
    
    /// A mutex value to prevent triggered action being call multiple time.
    fileprivate var stopReceivingBoundsChanged: Bool = false
    
    fileprivate var isPullingFromTop: Bool {
        return visibleY <= 0
    }
    
    fileprivate var isPullingFromBottom: Bool {
        return visibleY + visibleHeight >= documentHeight
    }
    
    /// Callback function when the bounds of scroll view's content view changed.
    /// 3 things to do here: 1) update the pulling progress 2) perform Haptic Feedback and 3) call trigger action.
    @objc fileprivate func viewBoundsChanged(_ notification: Notification) {
        
        if documentHeight == oldDocumentHeight {
            oldVisibleY = visibleY
        }
        
        // 1) Update pulling progress and update supplementary view.
        // 2) Perform Haptic Feedback if needed. (see `_progress`'s `didSet`)
        updatePullingProgressIfNeeded()
        
        // 3) Trigger action if needed.
        triggerInstantActionIfNeeded()
        
    }
    
    
    // MARK: - Helper properties & functions to cleanup code above
    
    
    /// The y offset from document view's top.
    fileprivate var visibleY: CGFloat {
        return documentVisibleRect.origin.y
    }
    
    /// The height of visible content view.
    fileprivate var visibleHeight: CGFloat {
        return contentView.frame.size.height
    }
    
    fileprivate var oldDocumentHeight: CGFloat = 0
    fileprivate var oldVisibleY: CGFloat = 0
    
    /// The height of document view.
    fileprivate var documentHeight: CGFloat {
        return documentView?.frame.size.height ?? visibleHeight
    }
    
    /// A bool value indicate whether visible rect reach refresh view's trigger rect.
    fileprivate var overRefreshView: Bool {
        return visibleY <= -supplementalRefreshViewHeight
    }
    
    /// A bool value indicate whether visible rect reach loading view's trigger rect.
    fileprivate var overLoadingView: Bool {
        return visibleY + visibleHeight >= documentHeight + supplementalLoadingViewHeight
    }
    
    /// A bool value indicate whether scroll view is refreshing.
    fileprivate var _isRefreshing = false
    
    /// A bool value indicate whether scroll view is loading.
    fileprivate var _isLoading = false
    
    private func askDelegateForSupplementalRefreshViewIfNeeded() {
        if canPullToRefresh {
            supplementalRefreshViewHeight = refreshableDelegate.ixScrollView(self, heightOfSupplementaryElementOfKind: .refresh)
//            supplementalRefreshViewTriggeredHeight = refreshableDelegate.ixScrollView(self, triggeredThresholdOfSupplementaryElementOfKind: .refresh)
            supplementalRefreshView = refreshableDelegate.ixScrollView(self, viewForSupplementaryElementOfKind: .refresh)
            supplementalRefreshViewTriggerBehavior = refreshableDelegate.ixScrollView(self, triggerBehaviorOfSupplementaryElementOfKind: .refresh)
        }
    }
    
    private func askDelegateForSupplementalLoadingViewIfNeeded() {
        if canPullToLoad {
            supplementalLoadingViewHeight = refreshableDelegate.ixScrollView(self, heightOfSupplementaryElementOfKind: .load)
//            supplementalLoadingViewTriggeredHeight = refreshableDelegate.ixScrollView(self, triggeredThresholdOfSupplementaryElementOfKind: .load)
            supplementalLoadingView = refreshableDelegate.ixScrollView(self, viewForSupplementaryElementOfKind: .load)
            supplementalLoadingViewTriggerBehavior = refreshableDelegate.ixScrollView(self, triggerBehaviorOfSupplementaryElementOfKind: .load)
        }
    }
    
    private func observeBoundsChangedNotificationsIfNeeded() {
        if canPullToRefresh || canPullToLoad {
            NotificationCenter.default.addObserver(self, selector: #selector(viewBoundsChanged(_:)), name: NSView.boundsDidChangeNotification, object: contentView)
            contentView.postsBoundsChangedNotifications = true
        } else {
            contentView.postsBoundsChangedNotifications = false
            NotificationCenter.default.removeObserver(self, name: NSView.boundsDidChangeNotification, object: contentView)
        }
    }
    
    private func placeSupplementalElement(_ view: SupplementaryView?, ofKindToContentViewIfNeeded kind: SupplementaryElementKind) {
        if let view = view {
            contentView.addSubview(view)
            contentView.addConstraints(withVisualFormat: "H:|[v0]|", views: view)
            
            let height = kind == .refresh ? supplementalRefreshViewHeight : supplementalLoadingViewHeight
            view.addConstraint(view, .height, .equal, to: nil, .height, plus: height)
            
            if kind == .refresh {
                contentView.addConstraint(view, .bottom, .equal, to: documentView, .top)
            } else {
                contentView.addConstraint(view, .top, .equal, to: documentView, .bottom)
            }
        }
    }
    
    private func updateStoredSupplementaryElement(ofKind kind: SupplementaryElementKind, by flag: Bool) {
        if flag {
            if kind == .refresh {
                askDelegateForSupplementalRefreshViewIfNeeded()
            } else {
                askDelegateForSupplementalLoadingViewIfNeeded()
            }
        } else {
            if kind == .refresh {
                supplementalRefreshView = nil
            } else {
                supplementalLoadingView = nil
            }
        }
    }
    
    private func updatePullingProgressIfNeeded() {
        // if is pulling from top...
        if canPullToRefresh && isPullingFromTop {
            // calculate current progress
            progress = -visibleY / supplementalRefreshViewHeight
        // or is pulling from bottom...
        } else if canPullToLoad && isPullingFromBottom {
            // calculate current progress
            progress = (visibleY + visibleHeight - documentHeight) / -supplementalLoadingViewHeight
        }
    }
    
    private func performHapticFeedbackIfNeeded() {
        // are we allowed to perform Haptic Feedback?
        if triggeredWithHapticFeedback {
            // are we being refreshing or loading?
            if !_isRefreshing && !_isLoading {
                // did it pass the trigger threshold?
                if (abs(lastProgress) >= 2 && abs(progress) < 1) || (abs(lastProgress) < 2 && abs(progress) >= 1) {
                    // perform Haptic Feedback
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .drawCompleted)
                }
            }
        }
    }
    
    private func triggerInstantActionIfNeeded() {
        // is it already been triggered once?
        guard !stopReceivingBoundsChanged else { return }
        
        // trying to trigger refreshing
        if visibleY <= -supplementalRefreshViewHeight {
            stopReceivingBoundsChanged = true
            didTriggered = true
            
            // begin action if needed
            if supplementalRefreshViewTriggerBehavior == .instant {
                beginRefreshing()
            }
            
            // trying to trigger loading
        } else if visibleY + visibleHeight >= documentHeight + supplementalLoadingViewHeight {
            stopReceivingBoundsChanged = true
            didTriggered = true
            
            // begin action if needed
            if supplementalLoadingViewTriggerBehavior == .instant {
                beginLoading()
            }
        }
    }
}


// MARK: - Custom Clip View

class IXClipView: NSClipView {
    
    // MARK: - Init
    
    init(original clipView: NSClipView) {
        super.init(frame: clipView.frame)
        
        autoresizingMask = clipView.autoresizingMask
        autoresizesSubviews = clipView.autoresizesSubviews
        backgroundColor = clipView.backgroundColor
        translatesAutoresizingMaskIntoConstraints = clipView.translatesAutoresizingMaskIntoConstraints
        copiesOnScroll = clipView.copiesOnScroll
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    // MARK: - Super View's Properties
    
    fileprivate var supplementalRefreshView: NSView? {
        return (superview as? IXScrollView)?.supplementalRefreshView
    }

    var supplementalLoadingView: NSView? {
        return (superview as? IXScrollView)?.supplementalLoadingView
    }

    fileprivate var isRefreshing: Bool {
        return (superview as? IXScrollView)?._isRefreshing ?? false
    }
    
    fileprivate var isLoading: Bool {
        return (superview as? IXScrollView)?._isLoading ?? false
    }
    
    // MARK: - Overrides
    
    /// Update document rect when refreshing or loading to keep supplementary display without hidding.
    override var documentRect: NSRect {
        var rect = super.documentRect
        
        if isRefreshing {
            let height = supplementalRefreshView?.frame.size.height ?? 0
            rect.size.height += height
            rect.origin.y -= height
        }
        
        if isLoading {
            let height = supplementalLoadingView?.frame.size.height ?? 0
            rect.size.height += height
        }

        return rect
    }
    
    override var isFlipped: Bool {
        return true
    }
}

// MARK: - Helper Extensions

fileprivate extension NSView {
    func addConstraint(_ view1: NSView, _ attr1: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation, to view2: NSView?, _ attr2: NSLayoutConstraint.Attribute, plus constant: CGFloat = 0, multiple multiplier: CGFloat = 1) {
        view1.translatesAutoresizingMaskIntoConstraints = false
        view2?.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: constant))
    }
    
    func addConstraints(withVisualFormat formatString: String, views: NSView...) {
        var viewDictionary = [String: NSView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDictionary[key] = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formatString, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDictionary))
    }
}
