import WebKit

final class ChroniclingAmericaWebsiteViewController: UIViewController {

    // MARK: Properties

    var dismissHandler: ((Void) -> Void)?
    private let webView = WKWebView()

    // MARK: Init methods

    func commonInit() {
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

    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()

        view.addSubview(webView)
        webView.snp_makeConstraints { make in
            make.edges.equalTo(0)
        }

        let request = NSURLRequest(URL: NSURL(string: "http://chroniclingamerica.loc.gov/")!)
        webView.loadRequest(request)
    }
}
