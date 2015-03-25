Pod::Spec.new do |s|
  s.name = 'SwiftKeychainWrapper'
  s.version = '1.0.6'
  s.license = 'MIT'
  s.summary = 'A simple static wrapper for the iOS Keychain to allow you to use it in a similar fashion to user defaults. Written in Swift.'
  s.homepage = 'https://github.com/jrendel/SwiftKeychainWrapper'
  s.authors = { 'Jason Rendel' => 'jason@jasonrendel.com' }
  s.source = { :git => 'https://github.com/jrendel/SwiftKeychainWrapper.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'SwiftKeychainWrapper/*.{h,m,swift}'
end
