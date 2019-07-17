Pod::Spec.new do |spec|
  spec.name						= "LeeDropDownMenu"
  spec.version					= "0.0.1"
  spec.summary					= "Objective-C drop down menu view"
  spec.homepage					= "https://github.com/bolee/LeeDropDownMenu"
  spec.authors					= "bobolee"
  spec.license					= "MIT"
  spec.platform					= :ios, "8.0"
  spec.source					= { :git => "https://github.com/bolee/LeeDropDownMenu.git", :branch => "master" }
  spec.source_files				= "LeeDropDownMenu/*"
  spec.resource       = 'LeeDropDownMenu/LeeDropDownMenu.bundle'
end