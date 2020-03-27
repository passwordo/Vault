platform :ios, '11.0'
use_modular_headers!
inhibit_all_warnings!

target 'Vault1' do
    pod 'Crypto', :git => 'https://github.com/passlock/Crypto.git'
    pod 'SwiftProtobuf'
    
    pod 'SwiftLint'
    
    target 'Tests' do
        inherit! :search_paths
    end
end
