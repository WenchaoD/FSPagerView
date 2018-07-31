Pod::Spec.new do |s|

  s.name             = "FSPagerView"
  s.version          = "0.7.2"
  s.summary          = "FSPagerView is an elegant Screen Slide Library for making Banner、Product Show、Welcome/Guide Pages、Screen/ViewController Sliders."
  
  s.homepage         = "https://github.com/WenchaoD/FSPagerView"
  s.screenshots      = "https://cloud.githubusercontent.com/assets/5186464/22686432/19b567f8-ed5f-11e6-885d-bd660c98b507.gif"
  s.license          = 'MIT'
  s.author           = { "Wenchao Ding" => "f33chobits@gmail.com" }
  s.source           = { :git => "https://github.com/WenchaoD/FSPagerView.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.framework    = 'UIKit'
  s.source_files = 'Sources/*.swift'

end
