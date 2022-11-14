// Copyright © 2022 SpotHero, Inc. All rights reserved.

import Foundation

/// A validated email address.
public struct Email {
    /// A `String` representing the email.
    public let string: String

    /// The components of an email address.
    public let components: EmailComponents

    /// Construct an `Email` from a string if it's valid. Returns `nil` otherwise.
    ///
    /// For detailed errors use ``EmailComponents.init(email:)``
    /// - Parameter string: The string containing the email.
    public init?(string: String) {
        guard let components = try? EmailComponents(email: string) else {
            return nil
        }

        self.components = components
        self.string = components.string
    }
}
