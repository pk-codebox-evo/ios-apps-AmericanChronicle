//
//  PrevNextKeyboardAccessoryView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 2/27/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

import UIKit

class PrevNextKeyboardAccessoryView: UIView {

    var previousButtonTapHandler: (() -> Void)?
    var nextButtonTapHandler: (() -> Void)?

    private class ArrowButton: UIButton {

        enum Direction {
            case Back
            case Forward
        }

        private let direction: Direction

        init(direction: Direction) {
            self.direction = direction
            super.init(frame: CGRectZero)
            titleLabel?.font = Font.mediumBody
            titleLabel?.textAlignment = (direction == .Back) ? .Left : .Right
            let normalImage = (direction == .Back)
                ? UIImage.backArrowWithFillColor(UIColor.whiteColor())
                : UIImage.forwardArrowWithFillColor(UIColor.whiteColor())
            setImage(normalImage, forState: .Normal)
            let highlightedImage = (direction == .Back)
                ? UIImage.backArrowWithFillColor(Colors.lightBlueDull)
                : UIImage.forwardArrowWithFillColor(Colors.lightBlueDull)
            setImage(highlightedImage, forState: .Highlighted)
            setTitleColor(UIColor.whiteColor(), forState: .Normal)
            setTitleColor(Colors.lightBlueDull, forState: .Highlighted)

        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func backImageRectForContentRect(contentRect: CGRect) -> CGRect {
            var imageRect = CGRectZero
            if let imageSize = imageForState(state)?.size {
                imageRect.size.width = imageSize.width * 0.5
                imageRect.size.height = imageSize.height * 0.5
                imageRect.origin.x = Measurements.horizontalMargin
                imageRect.origin.y = (contentRect.height - imageRect.size.height) / 2.0
            }
            return imageRect
        }

        private func forwardImageRectForContentRect(contentRect: CGRect) -> CGRect {
            var imageRect = CGRectZero
            if let imageSize = imageForState(state)?.size {
                imageRect.size.width = imageSize.width * 0.5
                imageRect.size.height = imageSize.height * 0.5
                imageRect.origin.x = (contentRect.width - (Measurements.horizontalMargin + imageRect.size.width))
                imageRect.origin.y = (contentRect.height - imageRect.size.height) / 2.0
            }
            return imageRect
        }

        private override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
            switch direction {
            case .Back: return backImageRectForContentRect(contentRect)
            case .Forward: return forwardImageRectForContentRect(contentRect)
            }
        }

        private func backTitleRectForContentRect(contentRect: CGRect) -> CGRect {
            var titleRect = contentRect
            if imageForState(state) != nil {
                let imageRect = imageRectForContentRect(contentRect)
                titleRect.origin.x = imageRect.maxX + Measurements.horizontalSiblingSpacing
                titleRect.size.width = contentRect.size.width - titleRect.origin.x
            }
            return titleRect
        }

        private func forwardTitleRectForContentRect(contentRect: CGRect) -> CGRect {
            var titleRect = contentRect
            if imageForState(state) != nil {
                let imageRect = imageRectForContentRect(contentRect)
                titleRect.size.width = imageRect.origin.x - Measurements.horizontalSiblingSpacing
            }
            return titleRect
        }

        private override func titleRectForContentRect(contentRect: CGRect) -> CGRect {

            switch direction {
            case .Back: return backTitleRectForContentRect(contentRect)
            case .Forward: return forwardTitleRectForContentRect(contentRect)
            }
        }
    }

    private let previousButton: UIButton = {
        let button = ArrowButton(direction: .Back)

        return button
    }()

    private let nextButton: UIButton = {
        let button = ArrowButton(direction: .Forward)
        return button
    }()

    var previousButtonTitle: String? {
        get { return previousButton.titleForState(.Normal) }
        set {
            previousButton.setTitle(newValue, forState:.Normal)
            previousButton.hidden = newValue?.characters.count < 1
        }
    }

    var nextButtonTitle: String? {
        get { return nextButton.titleForState(.Normal) }
        set {
            nextButton.setTitle(newValue, forState:.Normal)
            nextButton.hidden = newValue?.characters.count < 1
        }
    }

    func commonInit() {
        backgroundColor = Colors.darkBlue

        previousButton.addTarget(self, action: #selector(PrevNextKeyboardAccessoryView.previousButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(previousButton)
        previousButton.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.width.equalTo(100)
        }

        nextButton.addTarget(self, action: #selector(PrevNextKeyboardAccessoryView.nextButtonTapped(_:)), forControlEvents: .TouchUpInside)
        addSubview(nextButton)
        nextButton.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.trailing.equalTo(0)
            make.width.equalTo(100)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    func previousButtonTapped(sender: UIButton) {
        previousButtonTapHandler?()
    }

    func nextButtonTapped(sender: UIButton) {
        nextButtonTapHandler?()
    }

}
