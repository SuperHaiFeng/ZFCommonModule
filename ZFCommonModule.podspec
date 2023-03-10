#
# Be sure to run `pod lib lint ZFCommonModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name         = "ZFCommonModule"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of ZFCommonModule."

  spec.homepage     = "https://github.com/SuperHaiFeng/ZFCommonModule"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  spec.license      = { :type => 'MIT License', :file => 'LICENSE' }
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "Macoming" => "zhangzhifang1013@gmail.com" }
  # Or just: spec.author    = "Macoming"
  # spec.authors            = { "Macoming" => "zhangzhifang@hinterstellar.com" }
  # spec.social_media_url   = "https://twitter.com/Macoming"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.platform     = :ios
  spec.platform     = :ios, "11.0"

  #  When using multiple platforms
  spec.ios.deployment_target = "11.0"

  spec.source       = { :git => "https://github.com/SuperHaiFeng/ZFCommonModule.git", :tag => "#{spec.version}" }


  if spec.version.to_s.include?'Binary'
      
      puts '-------------------------------------------------------------------'
      puts 'Notice:BinaryModule is binary now'
      puts '-------------------------------------------------------------------'
      spec.prepare_command = '/bin/bash binary_lib.sh'
      spec.source_files = 'Pod/Products/include/**'
      spec.ios.vendored_libraries = 'Pod/Products/lib/*.a'
      spec.public_header_files = 'Pod/Products/include/*.h'
  else
    spec.subspec "Decision" do |ss|
        ss.source_files = "ZFCommonModule/Classes/Decision/*.swift"
    end
    
    spec.subspec "Extension" do |ss|
      ss.source_files = "ZFCommonModule/Classes/Extension/*.swift"
    end
    
    spec.subspec "Model" do |ss|
      ss.source_files = "ZFCommonModule/Classes/Model/*.swift"
    end
    
    spec.subspec "Tools" do |ss|
      ss.source_files = "ZFCommonModule/Classes/Tools/*.swift"
    end
    
    spec.subspec "UI" do |ss|
      ss.source_files = "ZFCommonModule/Classes/UI/**/*"
      end
  end
  
  # spec.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

  spec.dependency "RxSwift", '6.2.0'
  spec.dependency "RxCocoa", '6.2.0'
  spec.dependency "SnapKit", '5.0.1'
  spec.dependency "MJRefresh", '3.7.5'
  spec.dependency "Tabman", '3.0.1'
    
end
