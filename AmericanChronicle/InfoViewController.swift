import MessageUI

final class InfoViewController: UIViewController {

    // MARK: Properties

    var dismissHandler: ((Void) -> Void)?

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = Fonts.mediumBody
        var text = "American Chronicle gets its data from the 'Chronicling America' website.\n"
        text += "\n'Chronicling America' is a project funded by the National Endowment"
        text += " for the Humanities and maintained by the Library of Congress."
        label.text = text
        return label
    }()
    private let websiteButton = TitleButton(title: "Visit chroniclingamerica.gov.loc")
    private let separator = UIImageView(image: UIImage.imageWithFillColor(Colors.lightBlueBright))
    private let suggestionsLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.darkGray
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.font = Fonts.mediumBody
        label.text = "Do you have a question, suggestion or complaint about the app?"
        return label
    }()
    private let suggestionsButton = TitleButton(title: "Send us a message")

    // MARK: Init methods

    func commonInit() {
        navigationItem.title = "About this app"
        navigationItem.setLeftButtonTitle("Dismiss", target: self, action: #selector(didTapDismissButton(_:)))
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: Internal methods

    func didTapDismissButton(sender: UIBarButtonItem) {
        dismissHandler?()
    }

    func didTapSuggestionsButton(sender: UIButton) {
        let vc = MFMailComposeViewController()
        vc.setSubject("American Chronicle")
        guard let supportEmail = NSProcessInfo.processInfo().environment["SUPPORT_EMAIL"] else { return }
        vc.setToRecipients([supportEmail])
        let body = "Version \(NSBundle.mainBundle().versionNumber), Build \(NSBundle.mainBundle().buildNumber)"
        vc.setMessageBody(body, isHTML: false)
        presentViewController(vc, animated: true, completion: nil)
    }

    func didTapWebsiteButton(sender: UIBarButtonItem) {
        let vc = ChroniclingAmericaWebsiteViewController()
        vc.dismissHandler = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let nvc = UINavigationController(rootViewController: vc)
        presentViewController(nvc, animated: true, completion: nil)
    }

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.lightBackground

        view.addSubview(bodyLabel)
        bodyLabel.snp_makeConstraints { make in
            make.top.equalTo(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        websiteButton.addTarget(self,
                                action: #selector(didTapWebsiteButton(_:)),
                                forControlEvents: .TouchUpInside)
        view.addSubview(websiteButton)
        websiteButton.snp_makeConstraints { make in
            make.top.equalTo(bodyLabel.snp_bottom).offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }

        view.addSubview(separator)
        separator.snp_makeConstraints { make in
            make.top.equalTo(websiteButton.snp_bottom).offset(Measurements.verticalMargin * 2)
            make.leading.equalTo(Measurements.horizontalMargin * 2)
            make.trailing.equalTo(-Measurements.horizontalMargin * 2)
            make.height.equalTo(1.0/UIScreen.mainScreen().nativeScale)
        }

        view.addSubview(suggestionsLabel)
        suggestionsLabel.snp_makeConstraints { make in
            make.top.equalTo(separator.snp_bottom).offset(Measurements.verticalMargin)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
        }

        suggestionsButton.addTarget(self,
                                    action: #selector(didTapSuggestionsButton(_:)),
                                    forControlEvents: .TouchUpInside)
        view.addSubview(suggestionsButton)
        suggestionsButton.snp_makeConstraints { make in
            make.top.equalTo(suggestionsLabel.snp_bottom)
                .offset(Measurements.verticalSiblingSpacing * 2)
            make.leading.equalTo(Measurements.horizontalMargin)
            make.trailing.equalTo(-Measurements.horizontalMargin)
            make.height.equalTo(Measurements.buttonHeight)
        }
    }
}
