#
# Be sure to run `pod lib lint FSPagerView.RxSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FSPagerView.RxSwift'
  s.version          = '0.0.1'
  s.summary          = 'Add RxSwift to common three party libraries.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.homepage         = 'https://github.com/yangKJ/FSPagerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangkejun' => 'ykj310@126.com' }
  s.source           = { :git => 'https://github.com/yangKJ/FSPagerView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.ios.deployment_target = '9.0'
  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.static_framework = true
  s.module_name      = 'FSPagerViewRxSwift'
  
  s.subspec 'FSPagerView' do |xx|
    xx.source_files = 'Sources/*.{swift,h,m}'
  end
  
  s.subspec 'RxSwift' do |xx|
    xx.source_files = 'RxSwift/*.swift'
    xx.dependency 'FSPagerView.RxSwift/FSPagerView'
    xx.dependency 'RxSwift'
    xx.dependency 'RxCocoa'
  end
  
  # s.resource_bundles = {
  #   'RxExtensions' => ['RxExtensions/Assets/*.png']
  # }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
end
