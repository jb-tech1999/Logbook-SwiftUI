# Changelog

All notable changes to the Fuel Logbook project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive project documentation
- README.md with detailed feature descriptions and usage guide
- CONTRIBUTING.md with contribution guidelines
- CHANGELOG.md for version tracking

### Changed
- N/A

### Fixed
- N/A

### Removed
- N/A

## [0.1.0] - 2024-03-07

### Added
- Initial project structure with SwiftUI
- User authentication with token-based login
- Vehicle management features:
  - Add new vehicles with make, model, registration, and year
  - View all registered vehicles
  - Delete vehicles with swipe gesture
  - Detailed vehicle information view
- Fuel log management features:
  - Add fuel logs with date, odometer, distance, cost, and liters
  - View logs filtered by vehicle
  - Automatic fuel economy calculation (km/L)
  - Detailed log view with all information
  - Sort logs by date (newest first)
- Backend integration with FastAPI
- Tab-based navigation (Logs, Cars, Stats)
- Persistent authentication using UserDefaults

### Known Issues
- Stats view is a placeholder with no implementation
- Backend URL is hardcoded
- Limited error handling for network failures
- No offline mode
- Some SwiftUI best practices not followed

## Version History

### Version Numbering

This project uses Semantic Versioning (SemVer):
- MAJOR version for incompatible API changes
- MINOR version for new functionality in a backward compatible manner
- PATCH version for backward compatible bug fixes

### Types of Changes

- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes

---

## Future Planned Features

### v0.2.0 (Planned)
- Implement statistics and analytics in Stats view
- Add fuel economy trend charts
- Improve error handling and user feedback

### v0.3.0 (Planned)
- Offline mode with local data caching
- Data export functionality (CSV, PDF)
- Enhanced vehicle details

### v1.0.0 (Planned)
- Full feature set stabilization
- Comprehensive testing
- Production-ready release
- App Store submission

---

[Unreleased]: https://github.com/jb-tech1999/Logbook-SwiftUI/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/jb-tech1999/Logbook-SwiftUI/releases/tag/v0.1.0
