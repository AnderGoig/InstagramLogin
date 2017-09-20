# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2017-09-20
### Added
- Code is now simplier and more clean.
### Changed
- Now you don't need your Client Secret to authenticate, so you don't have to store it into your client.
- The Progress View now uses the new block-based KVO.
### Removed
- On successful logins, the information about the authenticated user is not returned any more, just the access token.

## [1.0.3] - 2017-09-13
### Fixed
- The progress view now automatically adjusts, regardless of top bar height.

## [1.0.2] - 2017-09-10
### Added
- Carthage support.

## [1.0.1] - 2017-09-09
### Added
- Travis CI support.
### Fixed
- Pod configuration files.

## 1.0.0 - 2017-09-09
### Added
- Initial release of IGAuth.

[Unreleased]: https://github.com/AnderGoig/IGAuth/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/AnderGoig/IGAuth/compare/v1.0.3...v1.1.0
[1.0.3]: https://github.com/AnderGoig/IGAuth/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/AnderGoig/IGAuth/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/AnderGoig/IGAuth/compare/v1.0.0...v1.0.1
