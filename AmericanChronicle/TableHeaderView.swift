//
//  TableHeaderView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//



class TableHeaderView: UITableViewHeaderFooterView {
    var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    private let label = UILabel()
    func commonInit() {

        contentView.backgroundColor = UIColor.whiteColor()

        contentView.addSubview(label)
        label.font = Font.smallBody
        label.textColor = Colors.darkGray
        label.numberOfLines = 1
        label.snp_makeConstraints { make in
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.bottom.equalTo(-1.0)
            make.top.equalTo(1.0)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
