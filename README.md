# AmericanChronicle

## Style Guide ##

### Rule 0 ###

A class or struct should be divided into the following sections, in the following order:

1. Init methods
2. Deinit method (if one exists)
3. Public Properties
4. Public Methods
5. Internal Properties
6. Internal Methods
7. Private Properties
8. Private Methods

Each of these sections should be delimited by a `// MARK:` with the section's name. No other MARK's may be used within the class/struct body. 

### Rule 1 ###

When a class or struct conforms to a protocol, the protocol's properties and methods should be implemented in a new extension.

Reasoning: The class's properties and methods are organized by access. Including property methods in the main class means that either a) the protocol methods and properties will need to be mixed in with the class's other public methods or b) they will need to be isolated, separating any protocol properties from the class's custom properties.

### Rule 2 ###

Classes should always follow a mark of the format:

```swift
// MARK -
// MARK: <Class Name>
```

Structs should always follow a mark with the following format:

```swift
// MARK -
// MARK: <Struct Name>
```

Protocols should always follow a mark with the following format:

```swift
// MARK -
// MARK: <Protocol Name>
```

Protocol Extensions should always follow a mark with the following format:

```swift
// MARK: -
// MARK: <Class or Struct Name> (<Protocol Name>)
```

Reasoning: Xcode doesn't do a good job of emphasising types in its dropdown menu. MARKs make them more visible at a glance. They also encourage better separation between two types in the same file.

### Rule 3 ###

Following GitHub's lead, internal methods and properties should be explicitly marked as `internal`.

### Rule ###

Protocols should not declare properties.

Reasoning: Protocol implementations should be added as an extension, and stored properties cannot be defined in extensions.

### Rule ###

Delegate methods that are meant to be called by a view should be of the form `viewWouldLikeTo<Do Something>()`

### Rule ###

Use XCTAssert, not XCTAssertTrue. Usually more readable.

### Rule ###

When an init method's parameters require multiple lines, each parameter should be on a new line below the init keyword. The curly brace should be on its own line. For example:

public init (
        customer: Customer,
        customerService: CustomerService_Protocol = CustomerService(),
        analyticsService: StitchFixAnalyticsService = StitchFixAnalyticsService.sharedInstance(),
        viewValidator: PersonalInfoViewValidator_Protocol = PersonalInfoViewValidator(),
        emailValidator: EmailTextFieldValidator_Protocol = EmailTextFieldValidator(),
        errorPresenter: ErrorPresenter_Protocol = ErrorPresenter())
    {
        self.customer = customer
        self.customerService = customerService
        self.errorPresenter = errorPresenter
        self.viewValidator = viewValidator
        self.emailValidator = emailValidator
        super.init(analyticsService: analyticsService, screenName: "Edit personal info screen")
    } 

This looks funky if there's no scope keyword - another reason to always explicitly declare `internal`.