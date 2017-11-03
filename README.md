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
<img src="https://raw.githubusercontent.com/AnderGoig/InstagramLogin/master/InstagramLogin-Demo.gif" alt="InstagramLogin Demo (GIF)" width="376" height="668">
</p>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Second, go to your Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/), click on _Manage_ your client, and **uncheck** the option "**Disable implicit OAuth**" from the _Security_ tab.

Third, edit the `Constants.swift` file with your client info from Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/):

```swift
let clientID = "YOUR CLIENT ID GOES HERE"
let redirectURI = "YOUR REDIRECT URI GOES HERE"
```

Fourth, go ahead and test it! :rocket:

## Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 3.2+

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

Simply copy the file [InstagramLoginViewController.swift](InstagramLogin/Classes/InstagramLoginViewController.swift) into your Xcode project.


## Usage

1. Go to your Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/), click on _Manage_ your client, and **uncheck** the option "**Disable implicit OAuth**" from the _Security_ tab.

2. Set your client info from Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/):

    ```swift
    let clientID = "YOUR CLIENT ID GOES HERE"
    let redirectURI = "YOUR REDIRECT URI GOES HERE"
    ```

3. **Initialize** your `InstagramLoginViewController`:

    ```swift
    let vc = InstagramLoginViewController(clientID: clientID, redirectURI: redirectURI) { (accessToken) in
        guard let accessToken = accessToken else {
            print("Failed login")
            return
        }

        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            // Do your stuff ...
        }
    }
    ```

4. **Customize** it:

    ```swift
    // Login permissions (https://www.instagram.com/developer/authorization/)
    vc.authScope = "basic+public_content" // basic by default

    // ViewController title, website title by default
    vc.customTitle = "Instagram" // By default, the web title is displayed

    // Progress view tint color
    vc.progressViewTintColor = UIColor.green // #E1306C by default

    // 1Password integration
    vc.allowOnePasswordIntegration = false // true by default
    ```

5. **Show** it:

    ```swift    
    show(vc, sender: self)
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
