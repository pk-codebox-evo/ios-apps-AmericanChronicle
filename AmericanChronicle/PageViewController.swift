// MARK: -
// MARK: PageUserInterfaceDelegate protocol

protocol PageUserInterfaceDelegate: class {
    func userDidTapDone()
    func userDidTapCancel()
    func userDidTapShare(image: UIImage)
}

// MARK: -
// MARK: PageUserInterface protocol

protocol PageUserInterface {
    var pdfPage: CGPDFPageRef? { get set }
    var highlights: OCRCoordinates? { get set }
    var delegate: PageUserInterfaceDelegate? { get set }

    func showLoadingIndicator()
    func hideLoadingIndicator()
    func setDownloadProgress(progress: Float)
    func showErrorWithTitle(title: String?, message: String?)
}

// MARK: -
// MARK: PageViewController class

final class PageViewController: UIViewController, PageUserInterface, UIScrollViewDelegate {

    // MARK: Properties

    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorTitleLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!

    weak var delegate: PageUserInterfaceDelegate?

    lazy var pageView: PDFPageView = PDFPageView()

    private let toastButton = UIButton()
    private var presentingViewNavBar: UIView?
    private var presentingView: UIView?
    private var hidesStatusBar: Bool = true

    // MARK: Internal methods

    @IBAction func shareButtonTapped(sender: AnyObject) {

        let pdfRect = CGPDFPageGetBoxRect(pageView.pdfPage, .MediaBox)
        UIGraphicsBeginImageContext(pdfRect.size)
        if let ctx = UIGraphicsGetCurrentContext() {
            pageView.pdfPage?.drawInContext(ctx,
                                            boundingRect: pdfRect,
                                            withHighlights: pageView.highlights)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        delegate?.userDidTapShare(image)
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        delegate?.userDidTapDone()
    }

    @IBAction func didTapCancelButton(sender: AnyObject) {
        delegate?.userDidTapCancel()
    }

    @IBAction func didRecognizeTap(sender: AnyObject) {
        bottomBarBG.hidden = !bottomBarBG.hidden
    }

    // MARK: PageUserInterface methods

    var pdfPage: CGPDFPageRef? {
        get {
            return pageView.pdfPage
        }
        set {
            pageView.pdfPage = newValue
            pageView.frame = pageView.pdfPage?.mediaBoxRect ?? .zero
            view.setNeedsLayout()
        }
    }

    var highlights: OCRCoordinates? {
        get {
            return pageView.highlights
        }
        set {
            pageView.highlights = newValue
            view.setNeedsLayout()
        }
    }

    func showLoadingIndicator() {
        if isViewLoaded() {
            loadingView.alpha = 1.0
            activityIndicator.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        loadingView.alpha = 0
        activityIndicator.stopAnimating()
    }

    func setDownloadProgress(progress: Float) {
        progressView.progress = progress
    }

    func showErrorWithTitle(title: String?, message: String?) {
        errorTitleLabel.text = title
        errorMessageLabel.text = message
        errorView.hidden = false
    }

    func hideError() {
        errorView.hidden = true
    }

    @IBAction func errorOKButtonTapped(sender: AnyObject) {
        delegate?.userDidTapDone()
    }

    // MARK: UIScrollViewDelegate protocol

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return pageView
    }

    // MARK: UIViewController overrides

    override var modalPresentationStyle: UIModalPresentationStyle {
        get { return .OverCurrentContext }
        set { }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.addSubview(pageView)

        doneButton.setBackgroundImage(nil, forState: .Normal)
        doneButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        doneButton.setTitle(nil, forState: .Normal)
        doneButton.tintColor = UIColor.whiteColor()
        let doneImage = UIImage(named: "UIAccessoryButtonX")
        doneButton.setImage(doneImage?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)

        shareButton.setBackgroundImage(nil, forState: .Normal)
        shareButton.setTitleColor(UIColor.lightTextColor(), forState: .Normal)
        shareButton.setTitle(nil, forState: .Normal)
        shareButton.tintColor = UIColor.whiteColor()
        let actionImage = UIImage(named: "UIButtonBarAction")
        shareButton.setImage(actionImage?.imageWithRenderingMode(.AlwaysTemplate),
                             forState: .Normal)

        toastButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        toastButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        toastButton.layer.shadowColor = UIColor.blackColor().CGColor
        toastButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        toastButton.layer.shadowRadius = 1.0
        toastButton.layer.shadowOpacity = 1.0
        view.addSubview(toastButton)

        hideError()

        showLoadingIndicator()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        let scrollViewWidthOverPageWidth: CGFloat
        if let pageWidth = pageView.pdfPage?.mediaBoxRect.size.width where pageWidth > 0 {
            scrollViewWidthOverPageWidth = scrollView.bounds.size.width/pageWidth
        } else {
            scrollViewWidthOverPageWidth = 1.0
        }
        scrollView.minimumZoomScale = scrollViewWidthOverPageWidth
        scrollView.zoomScale = scrollView.minimumZoomScale
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
