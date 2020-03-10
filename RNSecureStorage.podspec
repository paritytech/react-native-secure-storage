
Pod::Spec.new do |s|
  s.name         = "RNSecureStorage"
  s.version      = "1.0.1"
  s.summary      = "React Native Secure Storage Module"
  s.description  = <<-DESC
                  RNSecureStorage
                   DESC
  s.homepage     = "https://github.com/paritytech/react-native-secure-storage/"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@parity.io" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/paritytech/react-native-secure-storage.git", :tag => "master" }
  s.source_files  = "RNSecureStorage/**/*.{h,m}"
  s.requires_arc = true

  s.dependency "React"

end

