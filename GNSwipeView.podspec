Pod::Spec.new do |s|
  s.name         = "GNSwipeView"
  s.version      = "0.0.2"
  s.summary      = "Swipe controller"
  s.description  = <<-DESC
                   Swipe controller with strategy support for creating custom swipe handling
                   DESC
  s.homepage     = "https://github.com/jakubknejzlik/GNSwipeView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Jakub Knejzlik" => "jakub.knejzlik@gmail.com" }
  s.platform     = :ios
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/jakubknejzlik/GNSwipeView.git", :tag => "0.0.2" }
  s.source_files  = "GNSwipeView/GNSwipeView/*.{h,m}"
  s.frameworks = "Foundation", "UIKit"
  s.requires_arc = true
  
end
