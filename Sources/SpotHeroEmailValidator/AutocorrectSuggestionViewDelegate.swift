// Copyright © 2022 SpotHero, Inc. All rights reserved.

#if canImport(UIKit)

    import Foundation

    protocol AutocorrectSuggestionViewDelegate: AnyObject {
        func suggestionView(_ suggestionView: SHAutocorrectSuggestionView, wasDismissedWithAccepted accepted: Bool)
    }

#endif
