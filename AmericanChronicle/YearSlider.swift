//
//  YearSlider.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

public class YearSlider: UIControl {

    private let slider = UISlider()
    private let minButton = UIButton()
    private let maxButton = UIButton()

    public var value: Int {
        get {
            println("{get} value called")

            let intValue = Int(round(slider.value))
            println("* returning slider.value as Int: \(intValue)")
            println("    - original slider.value: \(slider.value)")
            return intValue
        }
        set {
            println("{set} value called")
            let floatValue = Float(newValue)
            println("* setting slider.value to \(floatValue)")
            println("    - original newValue was \(newValue)")
            slider.value = floatValue
            updateUIForNewValues()
        }
    }

    public var minValue: Int {
        get {
            return Int(round(slider.minimumValue))
        }
        set {
            slider.minimumValue = Float(newValue)
            updateUIForNewValues()
        }
    }

    public var maxValue: Int {
        get {
            return Int(round(slider.maximumValue))
        }
        set {
            slider.maximumValue = Float(newValue)
            updateUIForNewValues()
        }
    }

    private func commonInit() {
        for subview in [slider, minButton, maxButton] {
            subview.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(subview)
        }

        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        minButton.addTarget(self, action: "minButtonTapped:", forControlEvents: .TouchUpInside)
        minButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        maxButton.addTarget(self, action: "maxButtonTapped:", forControlEvents: .TouchUpInside)
        maxButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
    }

    public required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func minButtonTapped(button: UIButton) {
        slider.value = slider.minimumValue
        sendActionsForControlEvents(.ValueChanged)
    }

    func maxButtonTapped(button: UIButton) {
        slider.value = slider.maximumValue
        sendActionsForControlEvents(.ValueChanged)
    }

    func sliderValueDidChange(slider: UISlider) {
        sendActionsForControlEvents(.ValueChanged)
    }

    private func updateUIForNewValues() {
        minButton.setTitle("\(minValue)", forState: .Normal)
        maxButton.setTitle("\(maxValue)", forState: .Normal)
    }



    // MARK: UIView overrides

    override public var state: UIControlState {
        return slider.state
    }

    override public func updateConstraints() {
        minButton.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }

        maxButton.snp_makeConstraints { make in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
        }

        slider.snp_makeConstraints { make in
            make.leading.equalTo(minButton.snp_trailing).offset(20.0)
            make.trailing.equalTo(maxButton.snp_leading).offset(-20.0)
            make.top.equalTo(0)
        }
        super.updateConstraints()
    }
}
