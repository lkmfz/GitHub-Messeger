//
//  MessageInputLayoutGuide.swift
//  GitHub-Messenger
//
//  Created by Luqman Fauzi on 4/3/2020.
//

import UIKit

public final class MessageInputLayoutGuide : UILayoutGuide {
    
    private var observer: KeyboardFrameObserver?

    public override var owningView: UIView? {
        didSet {
            guard let view = owningView else {
                observer = nil
                return
            }

            let topConstraint = view.bottomAnchor.constraint(equalTo: topAnchor)
            topConstraint.priority = .defaultHigh

            let heightConstraint = heightAnchor.constraint(equalToConstant: 0)

            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topConstraint,
                heightConstraint,
            ])

            topAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            observer = KeyboardFrameObserver(view: view) { [weak view] keyboardFrame, animated in
                guard let view = view else { return }
                
                topConstraint.constant = view.bounds.height - keyboardFrame.origin.y
                heightConstraint.constant = keyboardFrame.height
                
                if animated {
                    view.layoutIfNeeded()
                }
            }
        }
    }
}


final private class KeyboardFrameObserversManager : NSObject {

    static let shared = KeyboardFrameObserversManager()

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChangeFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }

    private let observers: NSHashTable<KeyboardFrameObserver> = NSHashTable.weakObjects()

    /// Previous recorded keyboard frame.
    private var keyboardFrame = CGRect.zero

    /// Enabled keyboard frame observing only when at least one observer register.
    private var isEnabled = false {
        didSet {
            guard isEnabled != oldValue else { return }
            
            if isEnabled {
                // KVO host view's frame sometimes can't get updated values. So instead, we use display link pulling.
                displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayLink))
                displayLink?.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
            } else {
                displayLink = nil
            }
        }
    }

    private var displayLink: CADisplayLink? {
        didSet {
            oldValue?.invalidate()
        }
    }

    @objc private func handleDisplayLink() {
        updateKeyboardFrameForObservers()
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        // endFrame == .zero, means the keyboard's frame is currently freely changed in iPad Undock mode.
        let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        if endFrame != .zero {
            updateKeyboardFrameForObservers(animated: true)
        }
    }

    @objc private func keyboardDidChangeFrame() {
        updateKeyboardFrameForObservers(forced: true)
    }

    /// Retrieve new keyboard frame. If frame did change, notify all observers.
    ///
    /// - Parameters:
    ///   - forced: A boolean indicated whether update keyboard frame no matter frame changed or not. The default value is false.
    ///   - animated: A boolean indicated whether the update should be perform with animation. The default value is false.
    private func updateKeyboardFrameForObservers(forced: Bool = false, animated: Bool = false) {
        guard let keyboardView = keyboardView else { return }
        
        let newFrame = keyboardView.frame
        guard forced || newFrame != keyboardFrame else { return }
        
        keyboardFrame = newFrame
        let keyboardBounds = keyboardView.bounds
        
        for observer in observers.allObjects {
            if let view = observer.view {
                let frame = view.convert(keyboardBounds, from: keyboardView as UICoordinateSpace) // iPad Slide Over Undock mode not align
                //                let frame = view.convert(keyboardFrame, from: UIScreen.main.coordinateSpace) // iPad Slide Over Dock mode not align
                observer.updateHandler(frame, animated)
            }
        }
    }

    /// The keyboardView aka UIInputSetHostView used to real-time calculate keyboard's position.
    private weak var _keyboardView: UIView?
    private var keyboardView: UIView? {
        if _keyboardView == nil {
            struct Classes {
                //                static let keyboardWindow = NSClassFromString("UIRemoteKeyboardWindow") as? NSObject.Type // for input view
                static let textEffectsWindow = NSClassFromString("UITextEffectsWindow") as? NSObject.Type // for input accessory view
                static let inputSetContainerView = NSClassFromString("UIInputSetContainerView") as? NSObject.Type
                static let inputSetHostView = NSClassFromString("UIInputSetHostView") as? NSObject.Type
            }
            
            // 1. UIRemoteKeyboardWindow > UIInputSetContainerView > UIInputSetHostView
            // 2. UITextEffectsWindow    > UIInputSetContainerView > UIInputSetHostView
            // *  UIRemoteKeyboardWindow will be removed and set to nil in iPad Split View when keyboard is hosting on another app, but UITextEffectsWindow won't
            
            for window in UIApplication.shared.windows.reversed() {
                let windowClass = type(of: window)
                if windowClass == Classes.textEffectsWindow {
                    if let containerView = window.subviews.first(where: { type(of: $0) == Classes.inputSetContainerView }),
                        let hostView = containerView.subviews.first(where: { type(of: $0) == Classes.inputSetHostView }) {
                        _keyboardView = hostView
                        break
                    }
                }
            }
        }
        return _keyboardView
    }

    private func runOnMainQueue(work: @escaping () -> Void) {
        if Thread.isMainThread {
            work()
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }

    func addObserver(_ observer: KeyboardFrameObserver) {
        runOnMainQueue {
            self.observers.add(observer)
            self.isEnabled = true
            
            // immediately notify the new observer current keyboard frame.
            if let keyboardView = self.keyboardView, let targetView = observer.view {
                let frame = targetView.convert(keyboardView.bounds, from: keyboardView as UICoordinateSpace)
                observer.updateHandler(frame, false)
            }
        }
    }
    
    func removeObserver(_ observer: KeyboardFrameObserver) {
        runOnMainQueue {
            self.observers.remove(observer)
            if self.observers.count == 0 {
                self.isEnabled = false
            }
        }
    }
}

/// Init to start observation, deinit or call invalidate() to stop observation.
public class KeyboardFrameObserver : NSObject {

    public private(set) weak var view: UIView?

    let updateHandler: (CGRect, Bool) -> Void

    public init(view: UIView, updateHandler: @escaping (_ frame: CGRect, _ animated: Bool) -> Void) {
        self.view = view
        self.updateHandler = updateHandler
        super.init()
        KeyboardFrameObserversManager.shared.addObserver(self)
    }

    deinit {
        invalidate()
    }

    /// Stop observation.
    public func invalidate() {
        KeyboardFrameObserversManager.shared.removeObserver(self)
    }
}

