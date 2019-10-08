# frozen_string_literal: true

Pod::Spec.new do |spec|
  # Root Specification
  s.name            = 'SpotHeroEmailValidator'
  s.version         = '2.0.0'

  spec.author       = { 'SpotHero' => 'dev@spothero.com' }
  spec.homepage     = 'https://github.com/SpotHero/SpotHeroEmailValidator-iOS'
  spec.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.source       = { :git => 'https://github.com/SpotHero/SpotHeroEmailValidator-iOS.git',
                        :tag => spec.version.to_s }
  spec.summary      = "An iOS email validator."

  spec.description  = <<-DESC
                        An iOS library that will provide basic email syntax validation as well as provide suggestions for possible typos 
                        (for example, test@gamil.con would be corrected to test@gmail.com).
                      DESC

  s.screenshots     = [
                      "https://raw.githubusercontent.com/spothero/SHEmailValidator/master/Screenshots/Screenshot%201.png", 
                      "https://raw.githubusercontent.com/spothero/SHEmailValidator/master/Screenshots/Screenshot%202.png", 
                      "https://raw.githubusercontent.com/spothero/SHEmailValidator/master/Screenshots/Screenshot%203.png"
                    ]

  # Platform
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  s.requires_arc = true

  # File Patterns
  s.source_files = 'Sources/SpotHeroEmailValidator/**/*.{h,m}'
  s.resources    = 'Sources/SpotHeroEmailValidator/data/DomainData.plist'
end
