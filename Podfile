platform :ios, '11.0'

target 'GalleryAppDemo' do
    use_frameworks!
    pod 'Texture'

    #networking
    pod 'Alamofire'
    pod 'AlamofireObjectMapper', '~> 5.2.0'

    # Rx
    pod 'RxSwift', '= 4.4.1'
    pod 'NSObject+Rx'
    pod 'RxOptional'
    pod 'RxCocoa', '= 4.4.1'
    pod 'RxDataSources'
    pod 'RxDataSources-Texture', '~> 1.1.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
        end
    end
end
