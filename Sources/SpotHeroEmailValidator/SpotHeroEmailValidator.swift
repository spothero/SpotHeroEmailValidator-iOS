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
    private typealias EmailParts = (username: String, domain: String, tld: String)

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
        
        if !self.ianaRegisteredTLDs.contains(emailParts.tld) {
            suggestedTLD = self.closestString(for: emailParts.tld, fromArray: self.commonTLDs, withTolerance: 0.5) ?? emailParts.tld
        }

        let fullDomain = "\(emailParts.domain).\(suggestedTLD)"
        var suggestedDomain = fullDomain
        
        if !self.commonDomains.contains(fullDomain) {
            suggestedDomain = self.closestString(for: fullDomain, fromArray: self.commonDomains, withTolerance: 0.25) ?? fullDomain
        }
        
        let suggestedEmailAddress = "\(emailParts.username)@\(suggestedDomain)"
        
        guard suggestedEmailAddress != emailAddress else {
            return nil
        }

        return suggestedEmailAddress
    }
    
    public func validateSyntax(of emailAddress: String) -> Bool {
        return emailAddress.isValidEmail()
//        guard !emailAddress.isEmpty else {
//            throw Error.blankAddress
//        }
//
//        let emailParts = try self.splitEmailAddress(emailAddress)
//
//        #warning("TODO: Replace with regex match, use proper email address checking.")
//        let fullEmailPredicate = NSPredicate(format: "SELF MATCHES %@", "^\\b.+@.+\\..+\\b$")
//
//        if !fullEmailPredicate.evaluate(with: emailAddress) {
//            throw Error.invalidSyntax
//        }
//
//        let username = emailParts.username
//        let domain = emailParts.domain
//        let tld = emailParts.tld
//
//        #warning("TODO: Replace with regex matches.")
//        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.!#$%&'*+-/=?^_`{|}~]+")
//        let domainPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-]+")
//        let tldPredicate = NSPredicate(format: "SELF MATCHES %@", "[A-Za-z][A-Z0-9a-z-]{0,22}[A-Z0-9a-z]")
//
//        if username.isEmpty || !usernamePredicate.evaluate(with: username) || username.hasPrefix(".") || username.hasSuffix(".") || (username as NSString).range(of: "..").location != NSNotFound {
//            throw Error.invalidUsername
//        } else if domain.isEmpty || !domainPredicate.evaluate(with: domain) {
//            throw Error.invalidDomain
//        } else if tld.isEmpty || !tldPredicate.evaluate(with: tld) {
//            throw Error.invalidTLD
//        }
//
//        return true
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
        let fullDomain = String(emailAddressParts.last ?? "")
        
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
        case invalidTLD
        case invalidUsername

        public var errorDescription: String? {
            switch self {
            case .blankAddress:
                return "The entered email address is blank."
            case .invalidDomain:
                return "The domain name section of the entered email address is invalid."
            case .invalidSyntax:
                return "The syntax of the entered email address is invalid."
            case .invalidTLD:
                return "The TLD section of the entered email address is invalid."
            case .invalidUsername:
                return "The username section of the entered email address is invalid."
            }
        }
    }
}

private extension String {
    /// RFC 5322 Official Standard Email Regex Pattern
    private static let emailRegexPattern = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#
    
    func isValidEmail() -> Bool {
        return self.range(of: Self.emailRegexPattern, options: .regularExpression) != nil
    }
}
