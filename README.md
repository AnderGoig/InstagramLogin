# IGAuth

[![CI Status](http://img.shields.io/travis/AnderGoig/IGAuth.svg?style=flat)](https://travis-ci.org/AnderGoig/IGAuth)
[![Version](https://img.shields.io/cocoapods/v/IGAuth.svg?style=flat)](http://cocoapods.org/pods/IGAuth)
[![License](https://img.shields.io/cocoapods/l/IGAuth.svg?style=flat)](http://cocoapods.org/pods/IGAuth)
[![Platform](https://img.shields.io/cocoapods/p/IGAuth.svg?style=flat)](http://cocoapods.org/pods/IGAuth)

> IGAuth allows iOS developers to authenticate users by their Instagram accounts.

`IGAuth` handles all the **Instagram authentication** process by showing a custom `UIViewController` with the login page and returning an access token that can be used to [request data from Instagram](https://www.instagram.com/developer/endpoints/).

Inspired by projects like [InstagramAuthViewController](https://github.com/Isuru-Nanayakkara/InstagramAuthViewController) and [InstagramSimpleOAuth](https://github.com/rbaumbach/InstagramSimpleOAuth), because of the need for a **simple** and **easy** way to authenticate Instagram users.

<p align="center">
<img src="https://raw.githubusercontent.com/AnderGoig/IGAuth/master/IGAuth-Demo.gif" alt="IGAuth Demo (GIF)" width="376" height="668">
</p>

## Features

- [x] Customizable Options
- [x] Multiple Accounts Login
- [x] 1Password Extension Support
- [ ] More Coming...

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Second, create a `Constants.swift` file with the following:

```swift
let clientID = "YOUR CLIENT ID GOES HERE"
let clientSecret = "YOUR CLIENT SECRET GOES HERE"
let redirectURI = "YOUR REDIRECT URI GOES HERE"
```

Third, go ahead and test it! :rocket:

## Requirements

* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

## Installation

### CocoaPods

IGAuth is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'IGAuth'
```

## Usage

- Set your client info from Instagram's [developer portal](https://www.instagram.com/developer/clients/manage/):

```swift
let clientID = "YOUR CLIENT ID GOES HERE"
let clientSecret = "YOUR CLIENT SECRET GOES HERE"
let redirectURI = "YOUR REDIRECT URI GOES HERE"
```

- **Initialize** your `IGAuthViewController`:

```swift
let vc = IGAuthViewController(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI) { (response) in
    guard let response = response else {
        print("An error occurred while login in Instagram")
        return
    }

    DispatchQueue.main.async {
        self.navigationController?.popViewController(animated: true)
        // Do your stuff ...
    }
}
```

- **Customize** it:

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

- **Show** it:

```swift    
show(vc, sender: self)
```

## Contributing to this project

If you have feature requests or bug reports, feel free to help out by sending pull requests or by [creating new issues](https://github.com/AnderGoig/IGAuth/issues/new). Please take a moment to
review the guidelines written by [Nicolas Gallagher](https://github.com/necolas):

* [Bug reports](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#bugs)
* [Feature requests](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#features)
* [Pull requests](https://github.com/necolas/issue-guidelines/blob/master/CONTRIBUTING.md#pull-requests)

## License

`IGAuth` is available under the MIT license. See the [LICENSE](LICENSE) file for more info.

## Credits

`IGAuth` is brought to you by [Ander Goig](https://github.com/AnderGoig) and [contributors to the project](https://github.com/AnderGoig/IGAuth/contributors). If you're using `IGAuth` in your project, attribution would be very appreciated.

## Author

Ander Goig – [goig.ander@gmail.com](mailto:goig.ander@gmail.com)

[https://github.com/AnderGoig/IGAuth](https://github.com/AnderGoig/IGAuth)
