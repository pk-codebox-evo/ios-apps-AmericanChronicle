# American Chronicle #

## The App ##

American Chronicle provides mobile access to the collection of digitized U.S. newspapers made available by Chronicling America.
It uses the project's' public API.

Chronicling America is a collaboration between the National Endowment for the Humanities and the Library of Congress to develop an Internet-based, searchable database of U.S. newspapers.

Note: American Chronicle is an independent product and is not associated in any way with the Chronicling America project, the Library of Congress, or the National Endowment for the Humanities.

(Screenshots)

(A link to the product website)
(A link to the app in the App Store)

## The Code ##

### Structure ###

#### VIPER ####

This project's code loosly follows the VIPER pattern, first [introduced by Mutual Mobile](http://mutualmobile.github.io/blog/2013/12/04/viper-introduction/). I first heard about it in [this objc.io article](https://www.objc.io/issues/13-architecture/viper/) by Jeff Gilbert and Conrad Stoll.

Any code that doesn't fit nicely into a module can be found in the App-wide group.
    
#### Flat File Directory ####

The project's files are organized within Xcode into groups, but are stored on disk in a single folder.
In my experience, keeping the Xcode groups and file structures organized is more of a headache than it's worth.

### Style ###

This project's style is enforced using [SwiftLint](https://github.com/realm/SwiftLint). You must
have SwiftLint installed to build the project.

For the most part, this project follows the rules as defined by SwiftLint. 
The differences can be found by inspecting this project's [.swiftlint.xml](.swiftlint.xml) file.

### License ###

American Chronicle is available under the [MIT license](LICENSE). 
