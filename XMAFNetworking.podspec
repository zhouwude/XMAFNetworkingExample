Pod::Spec.new do |s|
  s.name         = "XMAFNetworking"
  s.version      = "1.0.0"
  s.summary      = "一个基于AFNetworking 网络请求类库的封装"
  s.homepage     = "https://github.com/ws00801526/XMAFNetworkingExample"
  s.license      = "MIT"
  s.author             = { "XMFraker" => "3057600441@qq.com" }
  s.source       = { :git => "https://github.com/ws00801526/XMAFNetworkingExample.git", :tag => s.version }
  s.platform = :ios,8.0
  s.dependency 'AFNetworking', '~> 3.0' 
  s.default_subspec =  'Core' , 'Download' , 'Upload'
  s.frameworks = 'UIKit','Foundation'
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.subspec 'Core' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/Assistants/*.{h,m}",     
                      "XMAFNetworkExample/XMAFNetworking/Categories/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Services/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Components/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Components/CahceComponent/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Components/LogComponent/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/*.{h,m}"
    
    ss.public_header_files = "XMAFNetworkExample/XMAFNetworking/Assistants/*.h","XMAFNetworkExample/XMAFNetworking/Categories/*.h","XMAFNetworkExample/XMAFNetworking/Services/*.h","XMAFNetworkExample/XMAFNetworking/Components/*.h","XMAFNetworkExample/XMAFNetworking/Components/CahceComponent/*.h","XMAFNetworkExample/XMAFNetworking/Components/LogComponent/*.h","XMAFNetworkExample/XMAFNetworking/*.h"
    
  end

  s.subspec 'Download' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/Components/DownloadComponent/*.{h,m}"
    ss.dependency 'XMAFNetworking/Core'
  end

  s.subspec 'Upload' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/Components/UploadComponent/*.{h,m}"
    ss.dependency 'XMAFNetworking/Core' 
  end
end