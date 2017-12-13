# InstagramLogin

[![CI Status](http://img.shields.io/travis/AnderGoig/InstagramLogin.svg?style=flat)](https://travis-ci.org/AnderGoig/InstagramLogin)
[![License](https://img.shields.io/cocoapods/l/InstagramLogin.svg?style=flat)](http://cocoapods.org/pods/InstagramLogin)
[![Platform](https://img.shields.io/cocoapods/p/InstagramLogin.svg?style=flat)](http://cocoapods.org/pods/InstagramLogin)
[![Version](https://img.shields.io/cocoapods/v/InstagramLogin.svg?style=flat)](http://cocoapods.org/pods/InstagramLogin)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codebeat badge](https://codebeat.co/badges/973c1f62-6fc3-42bd-ae51-013d38cb6da7)](https://codebeat.co/projects/github-com-andergoig-instagramlogin-master)

> InstagramLogin allows iOS developers to authenticate users by their Instagram accounts.

`InstagramLogin` handles all the **Instagram authentication** process by showing a custom `UIViewController` with the login page and returning an access token that can be used to [request data from Instagram](https://www.instagram.com/developer/endpoints/).

Inspired by projects like [InstagramAuthViewController](https://github.com/Isuru-Nanayakkara/InstagramAuthViewController) and [InstagramSimpleOAuth](https://github.com/rbaumbach/InstagramSimpleOAuth), because of the need for a **simple** and **easy** way to authenticate Instagram users.

<p align="center">
    <img src="https://raw.githubusercontent.com/AnderGoig/InstagramLogin/master/.assets/InstagramLogin-Demo.gif"
         alt="InstagramLogin Demo (GIF)" width="375" height="667">
</p>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Second, go to your Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/), click on _Manage_ your client, and **uncheck** the option "**Disable implicit OAuth**" from the _Security_ tab.

Third, edit the `Constants.swift` file with your client info from Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/):

```swift
static let clientId = "<YOUR CLIENT ID GOES HERE>"
static let redirectUri = "<YOUR REDIRECT URI GOES HERE>"
```

Fourth, go ahead and test it! :rocket:

## Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

## Installation

### CocoaPods

`InstagramLogin` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'InstagramLogin'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

To integrate `InstagramLogin` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "AnderGoig/InstagramLogin"
```

Follow the detailed guidelines [here](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos).

### Manual installation

Simply copy all the Swift files from the [InstagramLogin/Classes](InstagramLogin/Classes) folder into your Xcode project.

## Usage

First of all, go to your Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/), click on _Manage_ your client, and **uncheck** the option "**Disable implicit OAuth**" from the _Security_ tab.

```swift
import InstagramLogin // <-- VERY IMPORTANT! ;)

class YourViewController: UIViewController {

    var instagramLogin: InstagramLoginViewController!

    // 1. Set your client info from Instagram's developer portal (https://www.instagram.com/developer/clients/manage)
    let clientId = "<YOUR CLIENT ID GOES HERE>"
    let redirectUri = "<YOUR REDIRECT URI GOES HERE>"

    func loginWithInstagram() {

        // 2. Initialize your 'InstagramLoginViewController' and set your 'ViewController' to delegate it
        instagramLogin = InstagramLoginViewController(clientId: clientId, redirectUri: redirectUri)
        instagramLogin.delegate = self

        // 3. Customize it
        instagramLogin.scopes = [.basic, .publicContent] // [.basic] by default; [.all] to set all permissions
        instagramLogin.title = "Instagram" // If you don't specify it, the website title will be showed
        instagramLogin.progressViewTintColor = .blue // #E1306C by default

        // If you want a .stop (or other) UIBarButtonItem on the left of the view controller
        instagramLogin.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissLoginViewController))

        // You could also add a refresh UIBarButtonItem on the right
        instagramLogin.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshPage))

        // 4. Present it inside a UINavigationController (for example)
        present(UINavigationController(rootViewController: instagramLogin), animated: true)
    }

    @objc func dismissLoginViewController() {
        instagramLogin.dismiss(animated: true)
    }

    @objc func refreshPage() {
        instagramLogin.reloadPage()
    }

    // ...
}

// MARK: - InstagramLoginViewControllerDelegate

extension YourViewController: InstagramLoginViewControllerDelegate {

    func instagramLoginDidFinish(accessToken: String?, error: InstagramError?) {

        // Whatever you want to do ...

        // And don't forget to dismiss the 'InstagramLoginViewController'
        instagramLogin.dismiss(animated: true)
    }
}
```

## Contributing to this project

If you have feature requests or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/AnderGoig/InstagramLogin/issues/new). Please take a moment to
review the guidelines written by [Nicolas Gallagher](https://github.com/necolas):

* [Bug reports](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#bugs)
* [Feature requests](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#features)
* [Pull requests](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#pull-requests)

## License

`InstagramLogin` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Credits

`InstagramLogin` is brought to you by [Ander Goig](https://github.com/AnderGoig) and [contributors to the project](https://github.com/AnderGoig/InstagramLogin/contributors). If you're using `InstagramLogin` in your project, attribution would be very appreciated.

## Author

Ander Goig, [goig.ander@gmail.com](mailto:goig.ander@gmail.com)

[https://github.com/AnderGoig/InstagramLogin](https://github.com/AnderGoig/InstagramLogin)
