# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'Runway-iOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Runway-iOS
  pod 'ReactorKit'
  pod 'RxAlamofire'
  pod 'RxFlow'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'RxKeyboard'

  pod 'NMapsMap', '~> 3.15.0'
  pod 'RxKakaoSDKCommon'
  pod 'RxKakaoSDKAuth'
  pod 'RxKakaoSDKUser'

#  pod 'SkeletonView'
  pod 'Kingfisher', '~> 7.0'
  pod 'SnapKit', '~> 5.6.0'
  pod 'lottie-ios'
  pod 'RealmSwift', '~>10'

  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  target 'Runway-iOSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Runway-iOSUITests' do
    # Pods for testing
  end
 
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

end
