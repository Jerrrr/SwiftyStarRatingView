Pod::Spec.new do |s|
  s.name         = "SwiftyStarRatingView"
  s.version      = "2.0.0"
  s.summary      = "A simple star rating view written with swift."
  s.homepage     = "https://github.com/Jerrrr/SwiftyStarRatingView"
  s.license      = { :type => "GPL-3.0", :file => "LICENSE" }
  s.author       = { "Jerry" => "chen.developer@foxmail.com" }
  s.platform     = :ios, "12.0"
  s.source       = { :git => "https://github.com/Jerrrr/SwiftyStarRatingView.git", :tag => s.version }
  s.source_files = "Source/SwiftyStarRatingView.swift"
  s.swift_versions = ["5.0"]
  s.requires_arc = true
end
