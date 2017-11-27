Pod::Spec.new do |s|
  s.name                = 'InstagramLogin'
  s.version             = '1.2.1'
  s.cocoapods_version   = '>= 1.1.0'
  s.authors             = { 'Ander Goig' => 'goig.ander@gmail.com' }
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage            = 'https://github.com/AnderGoig/InstagramLogin'
  s.source              = { :git => 'https://github.com/AnderGoig/InstagramLogin.git',
                            :tag => "v#{s.version}" }
  s.summary             = 'A simple way to authenticate Instagram accounts on iOS.'
  s.description         = <<-DESC
                            This library provides the ability to authenticate an Instagram account on iOS,
                            by showing a custom View Controller with Instagram's login page.
                          DESC

  s.ios.deployment_target = '9.0'

  s.source_files = 'InstagramLogin/Classes/**/*'

  # s.resource_bundles = {
  #   'InstagramLogin' => ['InstagramLogin/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
