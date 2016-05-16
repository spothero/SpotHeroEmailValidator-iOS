#!/usr/bin/env ruby

require 'plist'
require 'httparty'

puts("Updating IANA TLD list.")

plistPath = "SHEmailValidator/DomainData.plist"
domainDataPlist = Plist::parse_xml(plistPath)

# Fetch latest IANA TLDs.
response = HTTParty.get('http://data.iana.org/TLD/tlds-alpha-by-domain.txt')
tldArray = response.body.split("\n").map {|e| e.downcase}
tldArray.shift

domainDataPlist['IANARegisteredTLDs'] = tldArray

File.open(plistPath, 'w') { |f|
  f.write(domainDataPlist.to_plist)
}
