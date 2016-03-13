class DebugView : StitchFixScrollView {
    let namesDropDown = StitchFixDropdown()
    let fillWebView = AlternativeCTA(title: "FILL WEB FORM")
    let namesCreateCustomer = PrimaryCTA(title: "CREATE & SIGN IN")
    let applicationSystemSettings = SecondaryCTA(title: "Go To System Settings")
    let pushNotificationReset = SecondaryCTA(title: "Reset Pre-System Push Notification Alert")
    let sandboxButton = SecondaryCTA(title: "Developer Sandboxes")
    
    required init(frame: CGRect) {
        super.init()
        commonInit()
        translatesAutoresizingMaskIntoConstraints = true
    }
    
    func commonInit() {
        namesDropDown.options = ["Select Customer State", "Onboarding", "Scheduled", "Checkout", "Unscheduled", "Packed", "In Transit", "Delayed", "Truant", "Referrals"]
        initializeConstraints()
    }
    
    func initializeConstraints() {
        for v in [namesDropDown, fillWebView, namesCreateCustomer, pushNotificationReset, sandboxButton, applicationSystemSettings] {safelyAddSubview(v)}
        fillWebView.beginVerticalLayout(topMargin: 12).withWidth(250)
        .onTopOf(namesDropDown, spacing: 50)
        .onTopOf(namesCreateCustomer, spacing: 10)
        .onTopOf(pushNotificationReset, spacing: 50)
        .onTopOf(applicationSystemSettings, spacing: 25)
        .onTopOf(sandboxButton, spacing: 25)
        .finishVerticalLayout(bottomMargin: 12)
        
        fillWebView.horizontallyCenter()
        namesDropDown.horizontallyCenter()
        namesCreateCustomer.horizontallyCenter()
        pushNotificationReset.horizontallyCenter()
        applicationSystemSettings.horizontallyCenter()
        sandboxButton.horizontallyCenter()

        namesDropDown.marginToSuperview(trailing: 15, leading: 15)
        
    }
    
}
