Pod::Spec.new do |s|
  s.name         = 'Waaatcher'
  s.version      = '0.1.4'
  s.authors      = 'Chen', { 'Chen' => 'hechen.dream@gmail.com' }
  s.homepage     = 'https://github.com/hechen/Waaatcher.git'
  s.summary      = 'File Stream Event Wrapper for macOS'
  s.platform     = :osx, '10.13'
  s.source       = { :git => 'https://github.com/hechen/Waaatcher.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.license      = {
    :type => 'MIT',
    :file => 'LICENSE',
    :text => 'Permission is hereby granted ...'
  }
  
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |cs|
    cs.source_files = 'Source/*.swift'
  end
  
  s.subspec 'Rx' do |sp|
    sp.source_files = 'Source/Rx/**/**'
    
    sp.dependency 'Waaatcher/Core'
    sp.dependency 'RxSwift', '~> 5.0'
  end
  
end
