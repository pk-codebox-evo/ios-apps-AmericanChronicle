//
//  SearchFieldCell.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 9/1/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class SearchFieldCell: UICollectionViewCell {
    var searchField = SearchField()

    func commonInit() {
        searchField.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(searchField)

        searchField.snp_makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
}
