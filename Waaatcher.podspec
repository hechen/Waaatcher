Pod::Spec.new do |s|
  s.name         = 'Waaatcher'
  s.version      = '0.0.1'
  s.authors      = 'Chen', { 'Chen' => '' }
  s.homepage     = 'https://github.com/hechen/Waaatcher.git'
  s.summary      = 'File Watcher Wrapper for macOS'
  s.description  = 'File Watcher Wrapper for macOS'
  s.platform     = :osx
  s.osx.deployment_target  = '10.10'
  s.source       = { :git => 'https://github.com/hechen/Waaatcher.git', :tag => '0.0.1' }
  s.source_files = 'Source/**/**'
  s.swift_version = '4.2'
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE',
    :text => 'Permission is hereby granted ...'
  }
end
