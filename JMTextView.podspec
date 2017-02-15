#
# Be sure to run `pod lib lint JMTextView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMTextView'
  s.version          = '0.2.0'
  s.summary          = 'A replacement for UITextView that gives you a placeholder'

  s.homepage         = 'https://github.com/jmeggesto/JMTextView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jmeggesto' => 'jackie.meggesto@gmail.com' }
  s.source           = { :git => 'https://github.com/jmeggesto/JMTextView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JMTextView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JMTextView' => ['JMTextView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

