# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

source "https://github.com/CocoaPods/Specs"
source 'https://github.com/aliyun/aliyun-specs.git'

use_frameworks!
## workspace文件名
workspace 'CIMSDK.xcworkspace'

## 主工程路径
project './CIMKit/CIMKit.xcodeproj'


# ✅ 在这里插入 Flutter 模块配置
flutter_application_path = File.expand_path('../flutter_module', __dir__)


## 工程路径
target 'LuckyLandPro' do
project './NoaChatSDKCore/LuckyLandPro.xcodeproj'

  pod "AFNetworking", '4.0.1'
  pod 'MJExtension', '3.4.0'
  pod 'SocketRocket', '0.6.0'
  pod 'MMKV', '1.2.16'
  pod 'NullSafe', '2.0'
  pod 'Protobuf', '3.21.5'
  #新的架构实现SDK
  pod 'CocoaAsyncSocket', '7.6.5'
  pod 'SAMKeychain', '1.5.3'
  
  #音视频要求iOS13最低(SwiftUI)
  pod 'LiveKitClient', '1.0.8'

  #即构音视频
  pod 'ZegoExpressEngine', '3.5.0'

  
  # RAC
  pod 'ReactiveObjC', :inhibit_warnings => true
  
  # 网络监听
  pod 'NetworkStatus', :path => './NetWorkStatus/NetWorkStatus.podspec'
  
end

target 'LuckyLand' do
project './NoaChatKit/LuckyLand.xcodeproj'


load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
install_all_flutter_pods(flutter_application_path)

  pod "AFNetworking", '4.0.1'
  pod 'MJExtension', '3.4.0'
  pod 'SocketRocket', '0.6.0'
  pod 'MMKV', '1.2.16'
  pod 'NullSafe', '2.0'
  pod 'Protobuf', '3.21.5'
  #新的架构实现SDK
  pod 'CocoaAsyncSocket', '7.6.5'
  
  
  pod 'MJRefresh', '3.7.5'
  
  pod 'MBProgressHUD', '1.2.0'
  
  pod 'IQKeyboardManager'
  
  pod 'Masonry', '1.1.0'
  
  pod 'SAMKeychain', '1.5.3'
  
  pod 'SDWebImage', '5.20.0'
  #SVG图片格式
  pod 'SDWebImageSVGCoder', '1.6.1'
  #WebP图片格式(libwebp 1.2.4)
  pod 'SDWebImageWebPCoder', '0.9.1'
  pod 'SDWebImageFLPlugin'
  #空态界面展示
  pod 'DZNEmptyDataSet', '1.8.1'
  
 
  #超级播放器(最新版是收费的)
  pod 'TXLiteAVSDK_Player', '7.6.9355'
  
  #用此网络请求，封装了一个文件下载工具 ZCacheManager
  pod 'ASIHTTPRequest', '1.8.2'

  pod 'FMDB', '2.7.5'
  
  #界面嵌套
  pod 'JXCategoryView', '1.6.1'
  
  #音视频要求iOS13最低(SwiftUI)
  pod 'LiveKitClient', '1.0.8'

  #即构音视频
  pod 'ZegoExpressEngine', '3.5.0'
  
  #防止崩溃
  pod 'AvoidCrash', '2.5.2'

  #阿里云OSS
  pod 'AliyunOSSiOS'

  #aliyun云解析DNS
  pod 'AlicloudPDNS', '2.1.9'

  #亚马逊云存储 AWS S3
  pod 'AWSS3'
  
  #腾讯云存储
  pod 'QCloudCOSXML', '6.4.8'

  #swift
  #SnapKit
  pod 'SnapKit', '5.6.0'
  pod 'lottie-ios'
  pod 'UIView+AnimationExtensions'
  pod 'Canvas'
  #图片下载
  pod 'Kingfisher'
  #openinstall数据统计
  pod 'libOpenInstallSDK'

  # RAC
  pod 'ReactiveObjC', :inhibit_warnings => true
  
  # 网络监听
  pod 'NetworkStatus', :path => './NetWorkStatus/NetWorkStatus.podspec'
  
  # 加解密
  pod 'EncryptLib', :path => './EncryptLib/EncryptLib.podspec'

  # 主题配置
  pod 'TKThemeConfig', :path => './TKThemeConfig/TKThemeConfig.podspec'
  
  # GaOnchain 请求组件
  pod 'GaOnchainLib', :path => './GaOnchainLib/GaOnchainLib.podspec'
  

    
  pod "FSPlayer", :podspec => 'https://github.com/debugly/fsplayer/releases/download/1.0.2/FSPlayer.spec.json'
  
end

post_install do |installer|

  flutter_post_install(installer)

  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      # 部分 Pod（如 CocoaLumberjack）会声明 Swift 6.x，旧版 Xcode 只支持到 5.0
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
       target.build_configurations.each do |config|
         config.build_settings['CODE_SIGN_IDENTITY'] = ''
         config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
       end
    end
  end
end
