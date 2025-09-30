# Contributing to Fuel Logbook

Thank you for your interest in contributing to the Fuel Logbook project! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

## Code of Conduct

By participating in this project, you agree to maintain a respectful and inclusive environment for all contributors.

### Our Standards

- Be respectful and considerate in communication
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what is best for the community and project

## Getting Started

1. **Fork the Repository**
   ```bash
   # Click the "Fork" button on GitHub
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR-USERNAME/Logbook-SwiftUI.git
   cd Logbook-SwiftUI
   ```

3. **Set Up Upstream Remote**
   ```bash
   git remote add upstream https://github.com/jb-tech1999/Logbook-SwiftUI.git
   ```

4. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b bugfix/issue-description
   ```

## Development Process

### Before You Start Coding

1. Check existing issues to avoid duplicate work
2. Open an issue to discuss major changes before implementing
3. Make sure you have the latest code from upstream
   ```bash
   git fetch upstream
   git merge upstream/main
   ```

### While Coding

1. **Keep Changes Focused**: Each PR should address a single concern
2. **Write Clear Commit Messages**: Use descriptive commit messages
   ```
   Good: "Add fuel economy chart to stats view"
   Bad: "Fixed stuff"
   ```
3. **Test Your Changes**: Ensure the app builds and runs without errors
4. **Update Documentation**: If you change functionality, update relevant docs

### Code Organization

- Place new views in `Logbook/Views/`
- Place new view models in `Logbook/Models/`
- Place new services in `Logbook/Services/`
- Follow the existing MVVM architecture pattern

## Coding Standards

### Swift Style Guide

1. **Naming Conventions**
   - Classes and Structs: `PascalCase` (e.g., `CarViewModel`)
   - Functions and Variables: `camelCase` (e.g., `getAllCars`)
   - Constants: `camelCase` (e.g., `maxRetries`)

2. **Code Formatting**
   - Use 4 spaces for indentation (not tabs)
   - Maximum line length: 120 characters
   - Add blank lines between functions for readability

3. **SwiftUI Best Practices**
   - Extract complex views into separate components
   - Use `@Published` for observable properties in ViewModels
   - Prefer `@StateObject` for creating ViewModels in views
   - Use `@ObservedObject` for passing ViewModels

4. **Comments**
   ```swift
   // Good: Explain WHY, not WHAT
   // Calculate fuel economy to show user's efficiency
   let fuelEconomy = distance / litersPurchase
   
   // Avoid: Stating the obvious
   // Divide distance by liters
   let fuelEconomy = distance / litersPurchase
   ```

5. **Error Handling**
   - Always handle errors gracefully
   - Provide meaningful error messages to users
   - Log errors for debugging purposes

### Example Code Structure

```swift
//
//  YourViewModel.swift
//  Logbook
//
//  Created by Your Name on YYYY/MM/DD.
//

import Foundation

class YourViewModel: ObservableObject {
    @Published var yourProperty: String = ""
    
    func yourFunction() {
        // Implementation
    }
}
```

## Pull Request Process

### Before Submitting

1. **Ensure Code Quality**
   - [ ] Code builds without errors
   - [ ] App runs without crashes
   - [ ] No compiler warnings introduced
   - [ ] Code follows style guidelines

2. **Update Documentation**
   - [ ] Update README.md if needed
   - [ ] Add inline comments for complex logic
   - [ ] Update CHANGELOG.md (if exists)

3. **Test Thoroughly**
   - [ ] Test on iOS simulator
   - [ ] Test on physical device (if possible)
   - [ ] Test edge cases and error scenarios
   - [ ] Verify backward compatibility

### Submitting the PR

1. **Push Your Changes**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to the original repository on GitHub
   - Click "New Pull Request"
   - Select your fork and branch
   - Fill in the PR template (if available)

3. **PR Description Should Include**
   - Clear description of changes
   - Related issue number (if applicable)
   - Screenshots (for UI changes)
   - Testing performed
   - Any breaking changes

### Example PR Description

```markdown
## Description
Adds fuel economy chart to the stats view using SwiftUI Charts framework.

## Related Issue
Closes #42

## Changes Made
- Implemented line chart showing fuel economy over time
- Added filter to view data by vehicle
- Updated StatsView with new chart component

## Screenshots
[Attach screenshots here]

## Testing
- Tested on iPhone 14 simulator (iOS 16.0)
- Verified chart updates when switching vehicles
- Tested with empty data set

## Breaking Changes
None
```

### After Submitting

- Respond to reviewer feedback promptly
- Make requested changes in new commits
- Keep the discussion professional and constructive

## Reporting Bugs

### Before Reporting

1. Check if the bug has already been reported
2. Verify the bug exists in the latest version
3. Collect relevant information

### Bug Report Template

```markdown
## Bug Description
A clear description of what the bug is.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Environment
- iOS Version: [e.g., 16.0]
- Device: [e.g., iPhone 14]
- App Version: [e.g., 1.0]

## Screenshots
If applicable, add screenshots.

## Additional Context
Any other relevant information.
```

## Suggesting Enhancements

### Enhancement Proposal Template

```markdown
## Feature Description
Clear description of the proposed feature.

## Motivation
Why is this feature needed? What problem does it solve?

## Proposed Solution
How would you implement this feature?

## Alternatives Considered
What other approaches did you consider?

## Additional Context
Mockups, examples, or related features.
```

## Development Tips

### Common Issues and Solutions

1. **Build Errors**
   - Clean build folder: `Cmd + Shift + K`
   - Reset package cache: `File > Packages > Reset Package Caches`

2. **Simulator Issues**
   - Reset simulator: `Device > Erase All Content and Settings`

3. **Code Signing**
   - Use your own development team in Xcode settings
   - Don't commit signing configurations

### Useful Xcode Shortcuts

- `Cmd + B`: Build
- `Cmd + R`: Run
- `Cmd + .`: Stop
- `Cmd + Shift + K`: Clean build folder
- `Cmd + Shift + O`: Quick open file

## Questions?

If you have questions not covered in this guide:
1. Check existing issues and discussions
2. Open a new issue with the "question" label
3. Be specific and provide context

## Attribution

When you contribute code, you agree that your contribution will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in the project documentation and release notes.

Thank you for contributing to Fuel Logbook! 🚗⛽
