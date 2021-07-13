Pod::Spec.new do |spec|
  spec.name         = "MKProgressHUD"
  spec.version      = "0.0.1"
  spec.summary      = "MKHUD"
  spec.description  = <<-DESC
                    HUD BY SWIFT.
                   DESC
  spec.author       = { 'spring' => 'liudajun2008@gmail.com' }
  spec.homepage     = "https://github.com/jackystd"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.source       = { :git => "https://github.com/jackystd/MKHUD.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '10.0'
  spec.source_files  = "MKHUD/core/*.swift"
  spec.frameworks   = "CoreGraphics", "QuartzCore"
  spec.swift_version = ['4.2', '5.0']
  spec.requires_arc = true
end