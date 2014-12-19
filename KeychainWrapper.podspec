Pod::Spec.new do |s|
  s.name = 'KeychainWrapper'
  s.version = '1.0.3'
  s.license = 'MIT'
  s.summary = 'A simple static wrapper for the iOS Keychain to allow you to use it in a similar fashion to user defaults. Written in Swift.'
  s.homepage = 'https://github.com/jrendel/KeychainWrapper'
  s.authors = { 'Jason Rendel' => 'unkown@jasonrendel.com' }
  s.source = { :git => 'https://github.com/jrendel/KeychainWrapper.git', :tag => '1.0.3' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'KeychainWrapper/*.swift'
end
