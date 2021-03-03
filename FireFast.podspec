#
# Be sure to run `pod lib lint FireFast.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FireFast'
  s.version          = '0.2.3'
  s.summary          = 'Working with the FireBase library without any effort.'

  s.description      = <<-DESC
'The FireFast is a swift library that helps you to work with  Firebase services in a fast way. You only need to do the configurations to use these simple use-cases.'
                       DESC

  s.homepage         = 'https://github.com/behrad-kzm/FireFast'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'behrad-kzm' => 'behrad.kzm@gmail.com' }
  s.source           = { :git => 'https://github.com/behrad-kzm/FireFast.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5'
  s.static_framework = true
  
  s.source_files = 'FireFast/Src/**/*'

  s.dependency 'Firebase/Analytics'
  s.dependency 'Firebase/Auth'
  s.dependency 'GoogleSignIn'
  s.dependency 'Firebase/Firestore'
  s.dependency 'FBSDKLoginKit'
  s.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
