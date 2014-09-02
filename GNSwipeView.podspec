Pod::Spec.new do |s|
  s.name         = "GNSwipeView"
  s.version      = "0.0.1"
  s.summary      = "Swipe controller"

  s.description  = <<-DESC
                   Swipe controller
                   DESC

  s.homepage     = "https://github.com/jakubknejzlik/GNSwipeView"


  s.license      = "MIT"
  
  s.author             = { "Jakub Knejzlik" => "jakub.knejzlik@gmail.com" }

  s.platform     = :ios
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/jakubknejzlik/GNSwipeView.git", :tag => "0.0.1" }


  s.source_files  = "GNSwipeView/*.{h,m}"

  s.frameworks = "Foundation", "UIKit"

  s.requires_arc = true
  
end
