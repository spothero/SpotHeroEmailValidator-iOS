# frozen_string_literal: true

Pod::Spec.new do |spec|
  # Root Specification
  spec.name            = 'SpotHeroEmailValidator'
  spec.version         = '2.0.1'
  
  spec.swift_versions = ['5.1', '5.2']

  spec.author       = { 'SpotHero' => 'ios@spothero.com' }
  spec.homepage     = 'https://github.com/SpotHero/SpotHeroEmailValidator-iOS'
  spec.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.source       = { :git => 'https://github.com/SpotHero/SpotHeroEmailValidator-iOS.git',
                        :tag => spec.version.to_s }
  spec.summary      = "An iOS email validator."

  spec.description  = <<-DESC
                        An iOS library that will provide basic email syntax validation as well as provide suggestions for possible typos 
                        (for example, test@gamil.con would be corrected to test@gmail.com).
                      DESC

  spec.screenshots  = [
                      "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%201.png", 
                      "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%202.png", 
                      "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%203.png",
                    ]

  # Platform
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.requires_arc = true

  # File Patterns
  spec.source_files = 'Sources/SpotHeroEmailValidator/**/*.{h,m,swift}'
  spec.resources    = 'Sources/SpotHeroEmailValidator/data/DomainData.plist'
end
