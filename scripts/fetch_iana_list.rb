#!/usr/bin/env ruby

#  Copyright © 2019 SpotHero, Inc. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

require 'plist'
require 'httparty'

puts("Updating IANA TLD list.")

# Call from the scripts directory, so it can be called from any location
scripts_directory = File.dirname(__FILE__)

plistPath = "#{scripts_directory}/../Sources/SpotHeroEmailValidator/data/DomainData.plist"
domainDataPlist = Plist::parse_xml(plistPath)

# Fetch latest IANA TLDs.
response = HTTParty.get('http://data.iana.org/TLD/tlds-alpha-by-domain.txt')
tldArray = response.body.split("\n").map {|e| e.downcase}
tldArray.shift

domainDataPlist['IANARegisteredTLDs'] = tldArray

File.open(plistPath, 'w') { |f|
  f.write(domainDataPlist.to_plist)
}
