final class TitleButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)

        layer.shadowColor = Colors.darkGray.CGColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.4

        titleLabel?.font = Fonts.mediumBody
        setTitleColor(Colors.lightBlueBright, forState: .Normal)
        setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        setBackgroundImage(UIImage.imageWithFillColor(UIColor.whiteColor()), forState: .Normal)
        setBackgroundImage(UIImage.imageWithFillColor(Colors.lightBlueBright), forState: .Highlighted)
        setTitle(title, forState: .Normal)
    }

    override convenience init(frame: CGRect) {
        self.init(title: "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
