Pod::Spec.new do |s|
  s.name            = "Vault1"
  s.version         = "1.1.4"
  s.summary         = "Safe place for your encryption keys."
  s.homepage        = "https://github.com/passlock/Vault"
  s.license         = "MIT"
  s.author          = "Passlock, Inc"
  s.platform        = :ios, "11.0"
  s.source          = { :git => "https://github.com/passlock/Vault.git", :tag => "#{s.version}" }

  s.default_subspec = 'Protobuf'

  s.subspec 'Core' do |ss|
    ss.source_files   = ["Sources/Vault1.swift", "Sources/Serializers/Serializer.swift", "Sources/Internal/UUID.swift"]

    ss.dependency 'Crypto'
  end

  s.subspec 'Protobuf' do |ss|
    ss.source_files = ['Sources/Serializers/Protobuf/**/*.{swift}']

    ss.dependency 'Vault1/Core'
    ss.dependency 'SwiftProtobuf'
  end

  s.subspec 'Json' do |ss|
    ss.source_files = ['Sources/Serializers/Json/**/*.{swift}']

    ss.dependency 'Vault1/Core'
  end
end
