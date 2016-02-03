Pod::Spec.new do |s|
  s.name         = "XMAFNetworkingExample"
  s.version      = "1.0.0"
  s.summary      = "一个基于AFNetworking 网络请求类库的封装"
  s.homepage     = "https://github.com/ws00801526/XMAFNetworkingExample"
  s.license      = "MIT"
  s.author             = { "XMFraker" => "3057600441@qq.com" }
  s.source       = { :git => "https://github.com/ws00801526/XMAFNetworkingExample.git", :tag => s.version }

  s.platform = :ios
  s.dependency 'AFNetworking'
  s.default_subspec =  'Core' , 'Download' , 'Upload'
  s.frameworks = 'UIKit','Foundation'
  s.user_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  s.subspec 'Core' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/Assistants/*.{h,m}",     
                      "XMAFNetworkExample/XMAFNetworking/Categories/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Services/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/Components/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/CacheComponent/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/LogComponents/*.{h,m}",
                      "XMAFNetworkExample/XMAFNetworking/*.{h,m}"

  s.subspec 'Download' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/DownloadComponents/*.{h,m}"


  s.subspec 'Upload' do |ss|
    ss.source_files = "XMAFNetworkExample/XMAFNetworking/UploadComponents/*.{h,m}"

end
