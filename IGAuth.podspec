#
# Be sure to run `pod lib lint IGAuth.podspec' to ensure this is a
# valid spec before submitting.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IGAuth'
  s.version          = '1.0.0'
  s.summary          = 'A simple way to authenticate an Instagram account on iOS.'

  s.description      = <<-DESC
This library provides the ability to authenticate an Instagram account on iOS,
by showing a custom View Controller with Instagram's login page.
                       DESC

  s.homepage         = 'https://github.com/AnderGoig/IGAuth'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AnderGoig' => 'goig.ander@gmail.com' }
  s.source           = { :git => 'https://github.com/AnderGoig/IGAuth.git', :tag => "v#{s.version.to_s}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'IGAuth/Classes/**/*'
  
  s.resource_bundles = {
    'IGAuth' => ['IGAuth/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency '1PasswordExtension'
end
