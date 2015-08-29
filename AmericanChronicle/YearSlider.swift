//
//  YearSlider.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/15/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

public class YearSlider: UIControl {

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Year"
        l.textAlignment = .Center
        return l
    }()
    private let slider = UISlider()
    private let minButton = UIButton()
    private let minMarker = UIView()
    private let midButton = UIButton()
    private let midMarker = UIView()
    private let maxButton = UIButton()
    private let maxMarker = UIView()


    public var value: Int {
        get { return Int(round(slider.value)) }
        set {
            slider.value = Float(newValue)
            updateUIForNewValues()
        }
    }

    public var minValue: Int {
        get { return Int(round(slider.minimumValue)) }
        set {
            slider.minimumValue = Float(newValue)
            updateUIForNewValues()
        }
    }

    public var maxValue: Int {
        get { return Int(round(slider.maximumValue)) }
        set {
            slider.maximumValue = Float(newValue)
            updateUIForNewValues()
        }
    }

    private func commonInit() {
        for subview in [titleLabel, minButton, midButton, maxButton, minMarker, midMarker, maxMarker, slider] {
            subview.setTranslatesAutoresizingMaskIntoConstraints(false)
            addSubview(subview)
        }

        slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        slider.setMinimumTrackImage(minTrackImage, forState: .Normal)
        slider.setMaximumTrackImage(maxTrackImage, forState: .Normal)

        minButton.addTarget(self, action: "minButtonTapped:", forControlEvents: .TouchUpInside)
        minButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        minMarker.backgroundColor = UIColor.grayColor()

        midButton.addTarget(self, action: "midButtonTapped:", forControlEvents: .TouchUpInside)
        midButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        minMarker.backgroundColor = UIColor.grayColor()

        maxButton.addTarget(self, action: "maxButtonTapped:", forControlEvents: .TouchUpInside)
        maxButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        maxMarker.backgroundColor = UIColor.grayColor()
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

    func midButtonTapped(button: UIButton) {
//        slider.value = slider.minimumValue
//        sendActionsForControlEvents(.ValueChanged)
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

    let minTrackImage: UIImage = {
        UIGraphicsBeginImageContext(CGSizeMake(15.0, 1.0))
        let end = UIBezierPath(rect: CGRect(x: 14.0, y: 0, width: 1.0, height: 1.0))
        UIColor.grayColor().set()
        end.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 14.0, bottom: 0, right: 0))
    }()

    let maxTrackImage: UIImage = {
        UIGraphicsBeginImageContext(CGSizeMake(15.0, 1.0))
        let end = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
        UIColor.grayColor().set()
        end.fill()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 14.0))
    }()

    // MARK: UIView overrides

    override public var state: UIControlState {
        return slider.state
    }

    override public func updateConstraints() {

        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(10.0)
            make.trailing.equalTo(0)

        }

        minButton.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
        }

        minMarker.snp_makeConstraints { make in
            make.width.equalTo(1.0)
            make.height.equalTo(20.0)
            make.centerX.equalTo(minButton.snp_centerX)
            make.top.equalTo(minButton.snp_bottom)
        }

        maxButton.snp_makeConstraints { make in
            make.trailing.equalTo(0)
            make.top.equalTo(0)
        }

        maxMarker.snp_makeConstraints { make in
            make.width.equalTo(1.0)
            make.height.equalTo(20.0)
            make.centerX.equalTo(maxButton.snp_centerX)
            make.top.equalTo(maxButton.snp_bottom)
        }

        slider.snp_makeConstraints { make in
            let thumbRect = (slider.thumbRectForBounds(slider.bounds, trackRect: slider.trackRectForBounds(slider.bounds), value: slider.value))
            let halfThumb = thumbRect.size.width / 2.0
            make.leading.equalTo(minMarker.snp_centerX).offset(-(halfThumb - 2.0))
            make.trailing.equalTo(maxMarker.snp_centerX).offset((halfThumb - 2.0))
            make.top.equalTo(minButton.snp_bottom)
            make.bottom.equalTo(0)
        }
        super.updateConstraints()
    }
}
