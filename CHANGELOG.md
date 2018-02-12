# Changelog

## [Unreleased]

## [1.3.0] (2017-12-13)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.2.1...v1.3.0)
### Added
- New option to **set all the scope permissions** using: `instagramLogin.scopes = [.all]`.
- New method `reloadPage()` in case you want a button (on the `UINavigationBar` maybe) to refresh the `WKWebView` (see the Example project).
### Changed
- The process of login has been **redesigned**, now it uses the **delegate pattern** instead of `completion:` method.
- The **Example project** has been **updated** with those changes.

## [1.2.1] (2017-11-27)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.2.0...v1.2.1)
### Fixed
- Carthage building problem (#1).

## [1.2.0] (2017-11-03)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.1.0...v1.2.0)
### Added
- Error handling for invalid requests.
- Code is now simpler and more clean.
### Changed
- Library renamed from IGAuth to InstagramLogin.
### Removed
- 1Password library extension.

## [1.1.0] (2017-09-20)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.0.3...v1.1.0)
### Added
- Code is now simpler and more clean.
### Changed
- Now you don't need your Client Secret to authenticate, so you don't have to store it into your client.
- The Progress View now uses the new block-based KVO.
### Removed
- On successful logins, the information about the authenticated user is not returned any more, just the access token.

## [1.0.3] (2017-09-13)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.0.2...v1.0.3)
### Fixed
- The progress view now automatically adjusts, regardless of top bar height.

## [1.0.2] (2017-09-10)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.0.1...v1.0.2)
### Added
- Carthage support.

## [1.0.1] (2017-09-09)
[Full Changelog](https://github.com/AnderGoig/InstagramLogin/compare/v1.0.0...v1.0.1)
### Added
- Travis CI support.
### Fixed
- Pod configuration files.

## [1.0.0] (2017-09-09)
### Added
- Initial release of IGAuth.

[Unreleased]: https://github.com/AnderGoig/InstagramLogin/compare/v1.3.0...develop
[1.3.0]: https://github.com/AnderGoig/InstagramLogin/tree/v1.3.0
[1.2.1]: https://github.com/AnderGoig/InstagramLogin/tree/v1.2.1
[1.2.0]: https://github.com/AnderGoig/InstagramLogin/tree/v1.2.0
[1.1.0]: https://github.com/AnderGoig/InstagramLogin/tree/v1.1.0
[1.0.3]: https://github.com/AnderGoig/InstagramLogin/tree/v1.0.3
[1.0.2]: https://github.com/AnderGoig/InstagramLogin/tree/v1.0.2
[1.0.1]: https://github.com/AnderGoig/InstagramLogin/tree/v1.0.1
[1.0.0]: https://github.com/AnderGoig/InstagramLogin/tree/v1.0.0
