// Copyright © 2022 SpotHero, Inc. All rights reserved.

import Foundation

/// A structure that parses emails into and constructs emails from their constituent parts.
public struct EmailComponents {
    /// The portion of an email before the @
    public let username: String

    /// The hostname of the domain
    public let hostname: String

    /// The top level domain.
    public let tld: String

    /// An email created from the components
    public let string: String

    /// Initializes an email using its constituent parts.
    /// - Parameters:
    ///   - username: The portion of an email before the @
    ///   - hostname: The hostname of the domain
    ///   - tld: The top level domain.
    public init(username: String, hostname: String, tld: String) {
        self.username = username
        self.hostname = hostname
        self.tld = tld
        self.string = "\(username)@\(hostname)\(tld)"
    }

    /// Parses an email and exposes its constituent parts.
    public init(email: String) throws {
        // Ensure there is exactly one @ symbol.
        guard email.filter({ $0 == "@" }).count == 1 else {
            throw SpotHeroEmailValidator.Error.invalidSyntax
        }

        let emailAddressParts = email.split(separator: "@")

        // Extract the username from the email address parts
        let username = String(emailAddressParts.first ?? "")
        // Extract the full domain (including TLD) from the email address parts
        let fullDomain = String(emailAddressParts.last ?? "")
        // Split the domain parts for evaluation
        let domainParts = fullDomain.split(separator: ".")

        guard domainParts.count >= 2 else {
            // There are no periods found in the domain, throw an error
            throw SpotHeroEmailValidator.Error.invalidDomain
        }

        // TODO: This logic is wrong and doesn't take subdomains into account. We should compare TLDs against the commonTLDs list."

        // Extract the domain from the domain parts
        let domain = domainParts.first?.lowercased() ?? ""

        // Extract the TLD from the domain parts, which are all the remaining parts joined with a period again
        let tld = domainParts.dropFirst().joined(separator: ".")

        // Complete initialization
        self.username = username
        self.hostname = domain
        self.tld = tld
        self.string = email
    }
}
