//
//  PagedKeyboard.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 3/13/16.
//  Copyright © 2016 ryanipete. All rights reserved.
//

class PagedKeyboard: UIView {

    private let pages: [UIView]
    private let topBorder = UIImageView(image: UIImage.imageWithFillColor(UIColor.whiteColor(), borderColor: UIColor.whiteColor()))
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    init(pages: [UIView]) {
        self.pages = pages
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 240))
        backgroundColor = Colors.lightBackground

        addSubview(topBorder)
        topBorder.snp_makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(1.0/UIScreen.mainScreen().nativeScale)
        }
        scrollView.scrollEnabled = false
        addSubview(scrollView)
        scrollView.snp_makeConstraints { make in
            make.top.equalTo(topBorder.snp_bottom)
            make.bottom.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }

        scrollView.addSubview(contentView)
        var prevPage: UIView? = nil
        for page in pages {
            contentView.addSubview(page)
            page.snp_makeConstraints { make in
                make.width.equalTo(self.snp_width)
                make.top.equalTo(0)
                make.bottom.equalTo(0)
                if let prevPage = prevPage {
                    make.leading.equalTo(prevPage.snp_trailing)
                } else {
                    make.leading.equalTo(0)
                }
            }
            prevPage = page
        }
        prevPage?.snp_makeConstraints { make in
            make.trailing.equalTo(0)
        }


        contentView.snp_makeConstraints { make in
            make.top.equalTo(self.snp_top)
            make.bottom.equalTo(self.snp_bottom)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }

    required convenience init?(coder: NSCoder) {
        self.init(pages: [])
    }

    override convenience init(frame: CGRect) {
        self.init(pages: [])
    }

    func setVisiblePage(pageIndex: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: CGFloat(pageIndex) * frame.size.width, y: 0), animated: animated)
    }
}
