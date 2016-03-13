class DeveloperSandboxViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    let realView = DeveloperSandboxView(frame: CGRectZero)
    let reuseID = "sandboxCell"
    var boxes : [(title: String, initializer: () -> UIViewController)]!
    
    override func loadView() {
        view = realView
    }
    
    override func viewDidLoad() {
        realView.tableView.dataSource = self
        realView.tableView.delegate = self
        realView.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        
        boxes = [
        (title: "Single Choice Question", initializer: sampleSingleChoiceViewControllerInit),
        (title: "Picker Question", initializer: sampleSurveyPickerViewControllerInit),
        (title: "Segmented Question", initializer: sampleSurveySegmentedViewControllerInit),
        (title: "Rating Question", initializer: sampleRatingViewControllerInit),
        (title: "Multi Choice Question", initializer: sampleMultiChoiceViewControllerInit),
        (title: "Text Field Question", initializer: sampleTextFieldQuestionViewControllerInit),
        (title: "Comment View Question", initializer: sampleCommentViewControllerInit),
        (title: "Question Navigator", initializer: sampleQuestionNavigatorViewControllerInit),
        (title: "Truant Home View", initializer: truantInit),
        (title: "Checkout Failed Home View", initializer: checkoutFailedInit),
        (title: "Onboarding card landing page", initializer: onboardingCardLandingInit),
        (title: "Account update credit card landing page", initializer: accountUpdateCardLandingInit),
        (title: "Survey Footer", initializer: surveyFooterInit),
        (title: "Sample Survey Date View", initializer: sampleSurveyDateViewControllerInit),
        (title: "Usability Style Profile", initializer: usabilityStudyViewControllerInit),
        (title: "Sample Survey Weight View", initializer: sampleSurveyWeightViewControllerInit),
        (title: "Sample Survey Height View", initializer: sampleSurveyHeightViewControllerInit)
        ]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let (title, _) = boxes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseID)
        cell?.textLabel?.text = title
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let (_, initializer) = boxes[indexPath.row]
        let vc = initializer()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sampleSurveyDateViewControllerInit() -> UIViewController {
        return SampleDateQuestionViewController()
    }
    
    func sampleSurveyPickerViewControllerInit() -> UIViewController {
        return SamplePickerViewController()
    }

    func sampleSurveyMultipleChoiceViewControllerInit() -> UIViewController {
        return SampleMultipleChoiceViewController()
    }
    
    func sampleSingleChoiceViewControllerInit() -> UIViewController {
        return SampleSingleChoiceViewController()
}

    func sampleCommentViewControllerInit() -> UIViewController {
        return SampleCommentViewController()
    }
    
    func sampleSurveySegmentedViewControllerInit() -> UIViewController {
        return SampleSegmentViewController()
    }

    func sampleRatingViewControllerInit() -> UIViewController {
        return SampleRatingViewController()
    }
    
    func sampleMultiChoiceViewControllerInit() -> UIViewController {
        return SampleMultipleChoiceViewController()
    }
    
    func sampleTextFieldQuestionViewControllerInit() -> UIViewController {
        return SampleTextFieldQuestionViewController()
    }

    func sampleSurveyHeightViewControllerInit() -> UIViewController {
        return SampleHeightQuestionViewController()
    }
    
    func sampleQuestionNavigatorViewControllerInit() -> UIViewController {
        return SampleQuestionNavigatorViewController()
}

    func sampleSurveyWeightViewControllerInit() -> UIViewController {
        return SampleWeightQuestionViewController()
    }
    
    func checkoutFailedInit() -> UIViewController {
        return CheckoutFailedHomeViewController()
    }
    
    func truantInit() -> UIViewController {
        return TruantHomeViewController()
    }

    func onboardingCardLandingInit() -> UIViewController {
        return OnboardingCardLandingViewController(onboardingNavigator: nil)
    }

    func accountUpdateCardLandingInit() -> UIViewController {
        return AccountCardLandingViewController()
    }

    func surveyFooterInit() -> UIViewController {
        return SampleSurveyFooterViewController()
    }

    func usabilityStudyViewControllerInit() -> UIViewController {
        return SampleQuestionNavigatorViewController()
    }

}
