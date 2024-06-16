# ChangeLog
## [1.0.2] - 2024-06-16
### Added
- Added User Interface for viewing:
  - List of Trips
  - List of Expenses
  - Map

### Fixed
- Refractored code to separate out reusable components:
  - two different theme buttons
  - nagivation bar
  - expense category icons/colors

## [1.0.1] - 2024-06-16
### Added
- Added Login Feature
  - By entering email password, user can login by calling the login api
  - Response token will be stored in the safe storage
  - Login image saved in assets
- Added theme button components for all the pages

### Fixed
- Fixed auth service to get the correct token from backend

## [1.0.0] - 2024-06-13
### Added
- Added Signup Feature
 - Users can now create an account by entering their email and password.
 - Verification email is sent to the user for account activation.
- Enhanced User Interface for Signup
 - Updated UI to provide a seamless and user-friendly signup experience.

### Changed
- Updated dependencies
