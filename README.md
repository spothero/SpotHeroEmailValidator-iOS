# SHEmailValidator

An iOS library that will provide basic email syntax validation as well as provide suggestions for possible typos (for example, test@gamil.con would be corrected to test@gmail.com).

## Screenshots
![Typo correction suggestion](Screenshots/Screenshot\ 1.png "Typo correction suggestion")
![Basic syntax validation](Screenshots/Screenshot\ 2.png "Basic syntax validation")
![Typo correction suggestion](Screenshots/Screenshot\ 3.png "Typo correction suggestion")

## Usage
### UITextField subclass
The SHEmailValidationTextField class is a pre-built UITextField subclass that will automatically validate its own input when it loses focus (such as when the user goes from the email field to the password field).  If a syntax error is detected, a popup will appear informing the user that the email address they entered is invalid.  If a probably typo is detected, a popup will appear that allows the user to accept the suggestion or dismiss the popup.  Using this class is as simple as replacing instances of UITextField with SHEmailValidationTextField.

#### Customization
To customize the default error message that appear for validation errors, use the `setDefaultErrorMessage:` method.  To set specific messages for specific errors, use the `setMessage:forErrorCode:` method.  To customize the text that appears above a typo suggestion, use the `setMessageForSuggestion:` method.

To customize the look and feel of the popup window that appears, the `fillColor`, `titleColor`, and `suggestionColor` properties can be set as desired.

### Basic syntax checking
	NSError *error = nil;
	[[[SHEmailValidator] validator] validateSyntaxOfEmailAddress:emailAddress withError:&error];
	
	if (error) {
		// An error occurred
		switch (error.code) {
			case SHBlankAddressError:
				// Input was empty
				break;
			case SHInvalidSyntaxError:
				// Syntax completely wrong (probably missing @ or .)
				break;
			case SHInvalidUsernameError:
				// Local portion of the email address is empty or contains invalid characters
				break;
			case SHInvalidDomainError:
				// Domain portion of the email address is empty or contains invalid characters
				break;
			case SHInvalidTLDError:
				// TLD portion of the email address is empty, contains invalid characters, or is under 2 characters long
				break;
		}
	} else {
		// Basic email syntax is correct
	} 

### Get typo correction suggestion
	NSError *error = nil;
	NSString *suggestion = [[[SHEmailValidator] validator] autocorrectSuggestionForEmailAddress:emailAddress withError:&error];
	
	if (error) {
		// The syntax check failed, so no suggestions could be generated
	} else if (suggestion) {
		// A probable typo has been detected and the suggestion variable holds the suggested correction
	} else {
		// No typo was found, or no suggestions could be generated
	}

## ARC
SHEmailValidator uses ARC. If your project is not ARC-compliant, simply set the `-fobjc-arc` flag on all SHEmailValidator source files.

## Apps Using this Library
This library is used in our own [SpotHero](https://itunes.apple.com/us/app/spothero-parking-best-parking/id499097243 "SpotHero") app. If you would like to see your app listed here as well, let us know you're using it!

## License
SHEmailValidator is released under the Apache 2.0 license.