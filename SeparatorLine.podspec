#
#  Be sure to run `pod spec lint SeparatorLine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "SeparatorLine"
  s.version      = “0.0.3”
  s.summary      = "Only one line of code, quick to add a line in the view."

  s.homepage     = "https://github.com/coder-zyp"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "coder-zyp" => "coder_zyp@163.com" }
  s.platform     = :ios
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/coder-zyp/SeparatorLine.git", :tag => s.version }


  s.source_files  = "SeparatorLine/SeparatorLine.swift"


  s.dependency "SnapKit", "~> 3.2.0"

end
