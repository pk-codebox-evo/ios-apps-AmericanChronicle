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
            return Int(round(slider.value))
        }
        set {
            slider.value = Float(newValue)
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
            return Int(round(slider.minimumValue))
        }
        set {
            slider.minimumValue = Float(newValue)
            updateUIForNewValues()
        }
    }

    private func commonInit() {
        for subview in [slider, minButton, maxButton] {
            subview.setTranslatesAutoresizingMaskIntoConstraints(false)
        }

        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        addSubview(slider)
        minButton.addTarget(self, action: "minButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(minButton)
        maxButton.addTarget(self, action: "maxButtonTapped:", forControlEvents: .TouchUpInside)
        addSubview(maxButton)
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

    private func updateUIForNewValues() {
        minButton.setTitle("\(minValue)", forState: .Normal)
        maxButton.setTitle("\(maxValue)", forState: .Normal)
    }

    private func sliderValueDidChange(slider: UISlider) {
        sendActionsForControlEvents(.ValueChanged)
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
            make.leading.equalTo(minButton.snp_trailing)
            make.trailing.equalTo(maxButton.snp_leading)
        }
        super.updateConstraints()
    }
}
