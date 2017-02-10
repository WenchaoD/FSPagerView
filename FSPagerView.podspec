Pod::Spec.new do |s|

  s.name             = "FSPagerView"
  s.version          = "0.1.0"
  s.summary          = "FSPagerView is an elegant Screen Slide Library implemented primarily with UICollectionView. It is extremely helpful for making Banner、Product Show、Welcome Pages、Screen/ViewController Sliders."
  
  s.homepage         = "https://github.com/WenchaoD/FSPagerView"
  s.license          = 'MIT'
  s.author           = { "Wenchao Ding" => "f33chobits@gmail.com" }
  s.source           = { :git => "https://github.com/WenchaoD/FSPagerView.git", :tag => s.version.to_s }

  s.platform     = :ios
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.framework    = 'UIKit'
  s.source_files = 'FSPagerView/*.{h,m}'

end
