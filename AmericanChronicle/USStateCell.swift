final class USStateCell: UICollectionViewCell {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.whiteColor()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = Colors.lightBlueBright
        label.textAlignment = .Center
        label.font = Fonts.largeBody
        label.frame = self.bounds
        label.highlightedTextColor = UIColor.whiteColor()
        contentView.addSubview(label)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
