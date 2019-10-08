Pod::Spec.new do |s|

  # SHEmailValidator now goes by SpotHeroEmailValidator
  s.deprecated_in_favor_of = 'SpotHeroEmailValidator'

  s.name         = "SHEmailValidator"
  s.license      = 'Apache License, Version 2.0'
  s.version      = "1.0.6"
  s.summary      = "iOS Email Validator"

  s.description  = <<-DESC
An iOS library that will provide basic email syntax validation as well as provide suggestions for possible typos (for example, test@gamil.con would be corrected to test@gmail.com).
		   DESC

  s.homepage     = "https://github.com/spothero/SpotHeroEmailValidator-iOS"
  s.screenshots  = "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%201.png", "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%202.png", "https://raw.githubusercontent.com/spothero/SpotHeroEmailValidator-iOS/master/Screenshots/Screenshot%203.png"

  s.authors      = { "spothero" => "admin@spothero.com", "EricKuck" => "eric@spothero.com" }

  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.source       = { :git => "https://github.com/spothero/SpotHeroEmailValidator-iOS.git", :tag => s.version.to_s }
  s.source_files = 'SHEmailValidator', 'SHEmailValidator/*.{h,m}'
  s.resources    = 'SHEmailValidator/DomainData.plist'

end
