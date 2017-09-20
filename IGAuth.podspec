Pod::Spec.new do |s|
  s.name             = 'IGAuth'
  s.version          = '1.0.3'
  s.summary          = 'A simple way to authenticate an Instagram account on iOS.'

  s.description      = <<-DESC
This library provides the ability to authenticate an Instagram account on iOS,
by showing a custom View Controller with Instagram's login page.
                       DESC

  s.homepage         = 'https://github.com/AnderGoig/IGAuth'
  s.screenshots      = 'https://raw.githubusercontent.com/AnderGoig/IGAuth/master/IGAuth-Scrennshot.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AnderGoig' => 'goig.ander@gmail.com' }
  s.source           = { :git => 'https://github.com/AnderGoig/IGAuth.git', :tag => "v#{s.version.to_s}" }

  s.ios.deployment_target = '9.0'

  s.source_files = 'IGAuth/Classes/**/*'

  s.resource_bundles = {
    'IGAuth' => ['IGAuth/Assets/*.png']
  }

  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency '1PasswordExtension'
end
