final class PagedKeyboard: UIView {

    private let pages: [UIView]
    private let topBorder = UIImageView(image: UIImage.imageWithFillColor(UIColor.whiteColor()))
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    init(pages: [UIView]) {
        self.pages = pages
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 240))
        backgroundColor = UIColor.whiteColor()

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
            make.top.equalTo(topBorder.snp_bottom).offset(12.0)
            make.bottom.equalTo(-12.0)
            make.leading.equalTo(12.0)
            make.trailing.equalTo(-12.0)
        }

        scrollView.addSubview(contentView)
        var prevPage: UIView? = nil
        for page in pages {
            contentView.addSubview(page)
            page.snp_makeConstraints { make in
                make.width.equalTo(self.snp_width).offset(-24.0)
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
            make.top.equalTo(self.snp_top).offset(12.0)
            make.bottom.equalTo(self.snp_bottom).offset(-12.0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
    }

    override convenience init(frame: CGRect) {
        self.init(pages: [])
    }

    @available(*, unavailable)
    required convenience init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setVisiblePage(pageIndex: Int, animated: Bool) {
        let x = CGFloat(pageIndex) * (frame.size.width - 24)
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }
}
