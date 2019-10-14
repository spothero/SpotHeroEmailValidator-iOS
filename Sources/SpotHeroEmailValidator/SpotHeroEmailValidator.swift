//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

// TODO: Remove NSObject when entirely converted into Swift
public class SpotHeroEmailValidator: NSObject {
    private typealias EmailParts = (username: String, hostname: String, tld: String)

    // TODO: Remove @objc when entirely converted into Swift
    @objc public static let shared = SpotHeroEmailValidator()
    
    private let commonTLDs: [String]
    private let commonDomains: [String]
    private let ianaRegisteredTLDs: [String]
    
    private override init() {
        var dataDictionary: NSDictionary?
        
        // All TLDs registered with IANA as of October 8th, 2019 at 11:28 AM CST (latest list at: http://data.iana.org/TLD/tlds-alpha-by-domain.txt)
        if let plistPath = Bundle(for: SpotHeroEmailValidator.self).path(forResource: "DomainData", ofType: "plist") {
            dataDictionary = NSDictionary(contentsOfFile: plistPath)
        }
        
        self.commonDomains = dataDictionary?["CommonDomains"] as? [String] ?? []
        self.commonTLDs = dataDictionary?["CommonTLDs"] as? [String] ?? []
        self.ianaRegisteredTLDs = dataDictionary?["IANARegisteredTLDs"] as? [String] ?? []
    }
    
    // TODO: Remove @objc when entirely converted into Swift
    @objc public func validateAndAutocorrect(emailAddress: String) throws -> SHValidationResult {
        let autocorrectSuggestion = self.autocorrectSuggestion(for: emailAddress)
        
        return SHValidationResult(passedValidation: autocorrectSuggestion?.isEmpty == false,
                                  autocorrectSuggestion: autocorrectSuggestion)
    }
    
    // TODO: Remove @objc when entirely converted into Swift
    @objc public func autocorrectSuggestion(for emailAddress: String) -> String? {
        guard let validated = try? self.validateSyntax(of: emailAddress), validated else {
//            throw Error.invalidSyntax
            return nil
        }

        guard let emailParts = try? self.splitEmailAddress(emailAddress) else {
            return nil
        }
        
        var suggestedTLD = emailParts.tld
        
        if !self.ianaRegisteredTLDs.contains(emailParts.tld),
            let closestTLD = self.closestString(for: emailParts.tld, fromArray: self.commonTLDs, withTolerance: 0.5) {
            suggestedTLD = closestTLD
        }
        
        var suggestedDomain = "\(emailParts.hostname).\(suggestedTLD)"
        
        if !self.commonDomains.contains(suggestedDomain),
            let closestDomain = self.closestString(for: suggestedDomain, fromArray: self.commonDomains, withTolerance: 0.25) {
            suggestedDomain = closestDomain
        }
        
        let suggestedEmailAddress = "\(emailParts.username)@\(suggestedDomain)"
        
        guard suggestedEmailAddress != emailAddress else {
            return nil
        }

        return suggestedEmailAddress
    }
    
    public func validateSyntax(of emailAddress: String) throws -> Bool {
        // Split the email address into parts
        let emailParts = try self.splitEmailAddress(emailAddress)
        
        // Ensure the username is valid by itself
        guard emailParts.username.isValidEmailUsername() else {
            throw Error.invalidUsername
        }
        
        // Combine the hostname and TLD into the domain"
        let domain = "\(emailParts.hostname).\(emailParts.tld)"
        
        // Ensure the domain is valid
        guard domain.isValidEmailDomain() else {
            throw Error.invalidDomain
        }
        
        // Ensure that the entire email forms a syntactically valid email
        guard emailAddress.isValidEmail() else {
            throw Error.invalidSyntax
        }
        
        return true
    }

    // TODO: Use better name for array parameter
    private func closestString(for string: String, fromArray array: [String], withTolerance tolerance: Float) -> String? {
        guard !array.contains(string) else {
            return nil
        }
        
        var closestString: String? = nil
        var closestDistance = Int.max
        
        // TODO: Use better name for arrayString parameter
        for arrayString in array {
            let distance = Int(string.levenshteinDistance(from: arrayString))
            
            if distance < closestDistance && Float(distance) / Float(string.count) < tolerance {
                closestDistance = distance
                closestString = arrayString
            }
        }
        
        return closestString
    }

    private func splitEmailAddress(_ emailAddress: String) throws -> EmailParts {
        let emailAddressParts = emailAddress.split(separator: "@")
        
        guard emailAddressParts.count == 2 else {
            // There are either no @ symbols or more than one @ symbol, throw an error
            throw Error.invalidSyntax
        }
        
        // Extract the username from the email address parts
        let username = String(emailAddressParts.first ?? "")
        // Extract the full domain (including TLD) from the email address parts
        let fullDomain = String(emailAddressParts.last ?? "")
        // Split the domain parts for evaluation
        let domainParts = fullDomain.split(separator: ".")
        
        guard domainParts.count >= 2 else {
            // There are no periods found in the domain, throw an error
            throw Error.invalidDomain
        }
        
        #warning("TODO: This logic is wrong and doesn't take subdomains into account. We should compare TLDs against the commonTLDs list.")
        
        // Extract the domain from the domain parts
        let domain = domainParts.first?.lowercased() ?? ""
        
        // Extract the TLD from the domain parts, which are all the remaining parts joined with a period again
        let tld = domainParts.dropFirst().joined(separator: ".")
        
        return (username, domain, tld)
    }
    
    
}

// MARK: - Extensions

public extension SpotHeroEmailValidator {
    enum Error: LocalizedError {
        case blankAddress
        case invalidDomain
        case invalidSyntax
        case invalidUsername

        public var errorDescription: String? {
            switch self {
            case .blankAddress:
                return "The entered email address is blank."
            case .invalidDomain:
                return "The domain name section of the entered email address is invalid."
            case .invalidSyntax:
                return "The syntax of the entered email address is invalid."
            case .invalidUsername:
                return "The username section of the entered email address is invalid."
            }
        }
    }
}

private extension String {
    /// RFC 5322 Official Standard Email Regex Pattern
    ///
    /// Sources:
    ///   - [How to validate an email address using a regular expression? (Stack Overflow)](https://stackoverflow.com/questions/201323/how-to-validate-an-email-address-using-a-regular-expression)
    ///   - [What characters are allowed in an email address? (Stack Overflow](https://stackoverflow.com/questions/2049502/what-characters-are-allowed-in-an-email-address)
    private static let emailRegexPattern = "\(Self.emailUsernameRegexPattern)@\(Self.emailDomainRegexPattern)"
    
    private static let emailUsernameRegexPattern = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")"#
    private static let emailDomainRegexPattern = #"(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
    
    func isValidEmail() -> Bool {
        return self.range(of: Self.emailRegexPattern, options: .regularExpression) != nil
    }
    
    func isValidEmailUsername() -> Bool {
        return !self.hasPrefix(".")
            && !self.hasSuffix(".")
            && (self as NSString).range(of: "..").location == NSNotFound
            && self.range(of: Self.emailUsernameRegexPattern, options: .regularExpression) != nil
    }
    
    func isValidEmailDomain() -> Bool {
        return self.range(of: Self.emailDomainRegexPattern, options: .regularExpression) != nil
    }
}
