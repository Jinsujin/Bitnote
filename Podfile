# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'DeveloperNote' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DeveloperNote
  pod 'Firebase/Analytics', '8.1.0'
  pod 'Google-Mobile-Ads-SDK'
  pod 'Firebase/Crashlytics'

  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RealmSwift'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'Sketch'
  pod 'SnapKit', '~> 5.0.0'

end

target 'ReviewWidgetExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReviewWidgetExtension
  pod 'RealmSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
    # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
