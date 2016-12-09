Pod::Spec.new do |s|
  s.name         = "SwiftyStarRatingView"
  s.version      = "1.0.1"
  s.summary      = "A simple star rating view written with swift."
  s.homepage     = "https://github.com/Jerrrr/SwiftyStarRatingView"
  s.license      = "MIT (LICENSE)"
  s.author       = { "Jerry" => "chen.developer@foxmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Jerrrr/SwiftyStarRatingView.git", :tag => s.version }
  s.source_files = "Source/SwiftyStarRatingView.swift"
  s.requires_arc = true
end
