#
#  Be sure to run `pod spec lint TestCrossProPOD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.

Pod::Spec.new do |s|
  s.name         = "TestCrossProPOD"
  s.version      = "0.0.2"
  s.summary      = "A Test POD of TestCrossProPOD."

  s.description  = <<-DESC
This is test results pod to test results integration POC!
DESC
  s.homepage     = "https://github.com/kumarabnit/TestCrossProPOD"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Kumar Abnit" => "avnitkumar10@gmail.com" }
  s.platform     = :ios, "9.0"
  #  When using multiple platforms
  #s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/kumarabnit/TestCrossProPOD.git", :tag => "#{s.version}" }
  s.source_files = "TestResultsPOD/Classes/**/*.{h,m,swift}"
  # s.resource  = "icon.png"
  s.resources = "TestResultsPOD/**/*.{storyboard,xib}"
  s.dependency 'TPMGCommon'
 
end
