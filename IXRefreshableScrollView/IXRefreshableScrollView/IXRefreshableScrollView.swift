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
    
    
    /// The height of supplementary view to trigger.
    /// This is use to trigger pulling action when pulling this far.
    /// By default, this return the value of ixScrollView(_: heightOfSupplementaryElementOfKind:) plus 10.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view that require the supplementary view trigger threshold.
    ///   - kind: A enum indicate the kind of supplementary view.
    /// - Returns: The trigger threshold of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, triggeredThresholdOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat
    
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
    
    
    /// Pulling action to execute when triggered.
    /// Refresh or load your data here.
    ///
    /// - Parameters:
    ///   - scrollView: The scroll view target.
    ///   - kind: A enum indicate the kind of supplementary view.
    func ixScrollView(_ scrollView: IXScrollView, actionForSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind)
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
    
    func ixScrollView(_ scrollView: IXScrollView, triggeredThresholdOfSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) -> CGFloat {
        return ixScrollView(scrollView, heightOfSupplementaryElementOfKind: kind) + 10
    }
    
    func ixScrollView(_ scrollView: IXScrollView, updateSupplementaryElement supplementaryView: IXScrollView.SupplementaryView, ofKind kind: IXScrollView.SupplementaryElementKind, withProgress progress: CGFloat) {
        
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
    
    func ixScrollView(_ scrollView: IXScrollView, actionForSupplementaryElementOfKind kind: IXScrollView.SupplementaryElementKind) {}
}


// MARK: - Extra function for protocol

extension IXScrollViewRefreshable where Self: IXScrollView {
    
    func beginRefreshing() {
        if _isRefreshing { return }
        _isRefreshing = true

        // TODO: animate to top
        
        ixScrollView(self, didTriggerSupplementaryElement: supplementalRefreshView!, ofKind: .refresh)
        ixScrollView(self, actionForSupplementaryElementOfKind: .refresh)
    }
    
    func stopRefreshing() {
        let y = self.documentVisibleRect.origin.y

        NSAnimationContext.runAnimationGroup({ _ in
            if y < 0 { contentView.animator().setBoundsOrigin(NSMakePoint(0, 0)) }
        }) {
            self._isRefreshing = false
            self.ixScrollView(self, didStopSupplementaryElement: self.supplementalRefreshView!, ofKind: .refresh)
        }
    }
    
    func beginLoading() {
        if _isLoading { return }
        _isLoading = true
        
        // TODO: animate to bottom
        
        ixScrollView(self, didTriggerSupplementaryElement: supplementalLoadingView!, ofKind: .load)
        ixScrollView(self, actionForSupplementaryElementOfKind: .load)
    }
    
    func stopLoading() {
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
            
            addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(20)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": indicator]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(20)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": indicator]))
        }
    }
    
    
    // MARK: - Public Properties
    
    
    /// A bool value control whether scroll view is refreshable.
    var canPullToRefresh = true
    
    /// A bool value control whether scroll view is loadable.
    var canPullToLoad = false

    /// A bool value indicate whether scroll view is refreshing.
    var isRefreshing: Bool { return _isRefreshing }
    
    /// A bool value indicate whether scroll view is loading.
    var isLoading: Bool { return _isLoading }
    
    /// Perform Haptic Feedback when reach the trigger threshold.
    var triggeredWithHapticFeedback = true
    
    
    // MARK: - Private Properties
    
    
    /// The delegate of IXScrollViewRefreshable.
    fileprivate lazy var refreshableDelegate: IXScrollViewRefreshable = self
    
    /// The y offset from document view's top.
    fileprivate var visibleY: CGFloat {
        return documentVisibleRect.origin.y
    }
    
    /// The height of visible content view.
    fileprivate var visibleHeight: CGFloat {
        return contentView.frame.size.height
    }
    
    /// The height of document view.
    fileprivate var documentHeight: CGFloat {
        return documentView?.frame.size.height ?? visibleHeight
    }
    
    /// A bool value indicate whether visible rect reach refresh view's trigger rect.
    fileprivate var overRefreshView: Bool {
        return visibleY <= -supplementalRefreshViewTriggeredHeight
    }
    
    /// A bool value indicate whether visible rect reach loading view's trigger rect.
    fileprivate var overLoadingView: Bool {
        return visibleY + visibleHeight >= documentHeight + supplementalLoadingViewTriggeredHeight
    }
    
    /// A bool value indicate whether scroll view is refreshing.
    fileprivate var _isRefreshing = false
    
    /// A bool value indicate whether scroll view is loading.
    fileprivate var _isLoading = false
    
    /// Height of refresh view.
    fileprivate var supplementalRefreshViewHeight: CGFloat = 0
    
    /// Trigger height of refresh view.
    fileprivate var supplementalRefreshViewTriggeredHeight: CGFloat = 0
    
    /// This control how scroll view should be trigger when pull from top. See SupplementaryTriggerBehavior for more info about different behavior.
    fileprivate var supplementalRefreshViewTriggerBehavior: SupplementaryTriggerBehavior = .overThreshold
    
    /// The view to display when pull from top.
    fileprivate var supplementalRefreshView: SupplementaryView? {
        didSet {
            // add view to scroll view with constraints.
            if let view = supplementalRefreshView {
                contentView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(-supplementalRefreshViewHeight))-[v0(\(supplementalRefreshViewHeight))]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
            }
        }
    }

    /// height of loading view.
    fileprivate var supplementalLoadingViewHeight: CGFloat = 0
    
    /// Trigger height of loading view.
    fileprivate var supplementalLoadingViewTriggeredHeight: CGFloat = 0
    
    /// This control how scroll view should be trigger when pull from bottom. See SupplementaryTriggerBehavior for more info about different behavior.
    fileprivate var supplementalLoadingViewTriggerBehavior: SupplementaryTriggerBehavior = .overThreshold
    
    /// The view to display when pull from bottom.
    fileprivate var supplementalLoadingView: SupplementaryView? {
        didSet {
            if let view = supplementalLoadingView {
                // add view to scroll view with constraints.
                contentView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
                contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(\(supplementalLoadingViewHeight))]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": view]))
                contentView.addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: documentView, attribute: .bottom, multiplier: 1, constant: 0))
            }
        }
    }
    
    
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
    fileprivate func setupSupplementalViews() {
        
        if canPullToRefresh || canPullToLoad {
        
            if canPullToRefresh {
                supplementalRefreshViewHeight = refreshableDelegate.ixScrollView(self, heightOfSupplementaryElementOfKind: .refresh)
                supplementalRefreshViewTriggeredHeight = refreshableDelegate.ixScrollView(self, triggeredThresholdOfSupplementaryElementOfKind: .refresh)
                supplementalRefreshView = refreshableDelegate.ixScrollView(self, viewForSupplementaryElementOfKind: .refresh)
                supplementalRefreshViewTriggerBehavior = refreshableDelegate.ixScrollView(self, triggerBehaviorOfSupplementaryElementOfKind: .refresh)
            }
            
            if canPullToLoad {
                supplementalLoadingViewHeight = refreshableDelegate.ixScrollView(self, heightOfSupplementaryElementOfKind: .load)
                supplementalLoadingViewTriggeredHeight = refreshableDelegate.ixScrollView(self, triggeredThresholdOfSupplementaryElementOfKind: .load)
                supplementalLoadingView = refreshableDelegate.ixScrollView(self, viewForSupplementaryElementOfKind: .load)
                supplementalLoadingViewTriggerBehavior = refreshableDelegate.ixScrollView(self, triggerBehaviorOfSupplementaryElementOfKind: .load)
            }
        
            contentView.postsFrameChangedNotifications = true
            contentView.postsBoundsChangedNotifications = true
            NotificationCenter.default.addObserver(self, selector: #selector(viewBoundsChanged(_:)), name: NSView.boundsDidChangeNotification, object: contentView)
        }
        
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
                
                if supplementalRefreshViewTriggerBehavior == .overThreshold {
                    if didTriggered && overRefreshView {
                        beginRefreshing()
                    }
                }
            }
            
            if canPullToLoad && !_isLoading {
                stopReceivingBoundsChanged = false
                
                if supplementalLoadingViewTriggerBehavior == .overThreshold {
                    if didTriggered && overLoadingView {
                        beginLoading()
                    }
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
    
    /// A Float value storing last progress value.
    fileprivate var lastProgress: CGFloat = 0
    
    fileprivate var isPullingFromTop: Bool {
        return visibleY <= 0
    }
    
    fileprivate var isPullingFromBottom: Bool {
        return visibleY + visibleHeight >= documentHeight
    }
    
    /// Callback function when the bounds of scroll view's content view changed.
    /// There are 3 things to do here: 1) update the pulling progress. 2) perform Haptic Feedback and 3) call trigger action.
    @objc fileprivate func viewBoundsChanged(_ notification: Notification) {
        
        var progress: CGFloat = 0
        
        // 1) Update pulling progress and update supplementary view.
        
        // if is pulling from top...
        if canPullToRefresh && isPullingFromTop {
            
            // calculate current progress
            progress = -visibleY / supplementalRefreshViewTriggeredHeight
            
            // call delegate to update supplementary view with the calculated progress
            refreshableDelegate.ixScrollView(self, updateSupplementaryElement: supplementalRefreshView!, ofKind: .refresh, withProgress: progress)
            
        // or is pulling from bottom...
        } else if canPullToLoad && isPullingFromBottom {
            
            // calculate current progress
            progress = (visibleY + visibleHeight - documentHeight) / supplementalLoadingViewTriggeredHeight
            
            // call delegate to update supplementary view with the calculated progress
            refreshableDelegate.ixScrollView(self, updateSupplementaryElement: supplementalLoadingView!, ofKind: .load, withProgress: progress)
        }
        
        // 2) Perform Haptic Feedback if needed.
        
        // are we allowed to perform Haptic Feedback?
        if triggeredWithHapticFeedback {
            // if yes, then...
            
            // are we being refreshing or loading?
            if !_isRefreshing && !_isLoading {
                // if not, then...
                
                // did it pass the trigger threshold?
                if (lastProgress >= 1 && progress < 1) || (lastProgress <= 1 && progress > 1) {
                    // if yes, then...
                    
                    // perform Haptic Feedback
                    NSHapticFeedbackManager.defaultPerformer.perform(.generic, performanceTime: .drawCompleted)
                }
            }
        }
        
        // store last progress
        lastProgress = progress
        
        // 3) Trigger action if needed.
        
        // is it already been triggered once?
        guard !stopReceivingBoundsChanged else { return }
        
        // trying to trigger refreshing
        if visibleY <= -supplementalRefreshViewTriggeredHeight {
            stopReceivingBoundsChanged = true
            didTriggered = true
          
            // begin action if needed
            if supplementalRefreshViewTriggerBehavior == .instant {
                beginRefreshing()
            }
            
        // trying to trigger loading
        } else if visibleY + visibleHeight >= documentHeight + supplementalLoadingViewTriggeredHeight {
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
    
    fileprivate var supplementalRefreshViewTriggeredHeight: CGFloat {
        return (superview as? IXScrollView)?.supplementalRefreshViewTriggeredHeight ?? 0
    }
    
    var supplementalLoadingView: NSView? {
        return (superview as? IXScrollView)?.supplementalLoadingView
    }
    
    fileprivate var canPullToRefresh: Bool {
        return (superview as? IXScrollView)?.canPullToRefresh ?? false
    }
    
    fileprivate var canPullToLoad: Bool {
        return (superview as? IXScrollView)?.canPullToLoad ?? false
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

