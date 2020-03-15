Pod::Spec.new do |s|
  s.name           = "Vault1"
  s.version        = "1.0.0"
  s.summary        = "Secure and Simple"
  s.homepage       = "https://github.com/passlock/Vault"
  s.license        = "MIT"
  s.author         = "Passlock, Inc"
  s.platform       = :ios, "11.0"
  s.source         = { :git => "https://github.com/passlock/Vault.git", :tag => "#{s.version}" }
  s.source_files   = "Sources", "Sources/**/*.swift"
  s.preserve_paths = "Sources/Proto"

  s.dependency 'Sodium', '~> 0.8'
  s.dependency 'SwiftProtobuf', '~> 1.0'
  s.dependency 'Crypto'
end
