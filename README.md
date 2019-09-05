# xkcd-ios
## Welcome to Vancouver Code Critique's 

### initial Setup
1. Clone the repo don't forget to fetch __srReview__ and __peerReview__ branches
2. This project uses __homeBrew__ if you do already have homeBrew installed 
run _brew update_ otherwise install homebrew using the following command 
_/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"_
Homebrew is a command-line tool that is used to install other development tools.
For more details about homebrew view there [site](https://brew.sh/) 
3. This project also uses __XcodeGen__ to avoid merge conflicts in the project file.
__XcodeGen__ is a command-line tool that creates/recreates a project file from a 
YAML specification contained in the _project.yml_ file. Details about how to write this YAML specification can be found [here](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md#general). The initial _project.yml_ file is configured such that any files added to the _source_ directory will be included in the _xkcd_ target. The _xkcd.project_ file has been added to the _.gitignore_ file for this repo. Instead of sharing this file which can lead to merge conflicts each developer will generate there own copy of the _xkcd.project_ file using __XcodeGen__ when the project is changed. For more details about __XcodeGen__ view their GitHub [repo](https://github.com/yonaskolb/XcodeGen)
To install __XcodeGen__ run _brew install xcodeGen_
4. This project also uses swiftLint. SwiftLint is a linting tool, that enforces
some swift style and syntax conventions. For more information about swift lint
see there [repo](https://github.com/realm/SwiftLint)
To install swiftLint run 'brew install swiftLint'

### Build the project
1. In terminal _cd_ into the project's root directory 
2. Run _make_ to build the project file. Make is a UNIX command-line tool that runs the commands contained in the makefile. The initial commands in this file delete the _xkcd.project_ file if it is present, and regenerates the _xkcd.project_ file using __XcodeGen__. More details about make can be found [here](https://en.wikipedia.org/wiki/Make_(software)#Behavior) and [here](https://en.wikipedia.org/wiki/Make_(software)#Rules)
3. Open _xkcd.xcodeproj_ with __Xcode__
4. You should now be able to build and run the project 

### Misc
- We will be using the AirBnB [Style guide](https://github.com/airbnb/swift)
- Out slack workspace is __CodeCritique.slack.com__
- xkcd [api docs](https://xkcd.com/json.html)
- Wireframes are available [here](https://drive.google.com/open?id=1Y-WynUGdnrcfIhpY74KbroAzQoGMhlJX)
- [slack invite](https://join.slack.com/t/codecritique/shared_invite/enQtNzI5OTE3MTA0MTQ5LTMzOTNjOTBlNGFmOGIyZGYxMTEzNWNjZjRlYzIxNTA2MDc2YmI0OWFhMmUyMGQyYjdjYWNmZGUwOWZkYTQ0YjY)


