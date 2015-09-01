//
//  TableHeaderView.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/30/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//



class TableHeaderView: UITableViewHeaderFooterView {
    let label = UILabel()
    func commonInit() {
        addSubview(label)
        label.setTranslatesAutoresizingMaskIntoConstraints(true)
        label.font = UIFont(name: "AvenirNext-Regular", size: UIFont.systemFontSize())
        label.snp_makeConstraints { make in
            make.leading.equalTo(10.0)
            make.bottom.equalTo(-4.0)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}
