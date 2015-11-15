//
//  KeyboardService.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 11/12/15.
//  Copyright © 2015 ryanipete. All rights reserved.
//

import Foundation

public class KeyboardService: NSObject {

    private var frameChangeHandlers: [String: (CGRect?) -> Void] = [:]

    static let sharedInstance = KeyboardService()
    private let notificationCenter: NSNotificationCenter
    public private(set) var keyboardFrame: CGRect? {
        didSet {
            if keyboardFrame != oldValue {
                for (_, handler) in frameChangeHandlers {
                    handler(keyboardFrame)
                }
            }
        }
    }

    public init(notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()) {
        self.notificationCenter = notificationCenter
        super.init()
    }

    public func applicationDidFinishLaunching() {
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        let keyboardFrameEndValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        keyboardFrame = keyboardFrameEndValue?.CGRectValue()
    }

    func keyboardWillHide(notification: NSNotification) {
        keyboardFrame = nil
    }

    public func addFrameChangeHandler(identifier: String, handler: (CGRect?) -> Void) {
        frameChangeHandlers[identifier] = handler
    }

    public func removeFrameChangeHandler(identifier: String) {
        frameChangeHandlers[identifier] = nil
    }

    deinit {
        notificationCenter.removeObserver(self)
    }
}