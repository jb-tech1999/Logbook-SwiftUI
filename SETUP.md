# Development Setup Guide

This guide will help you set up the Fuel Logbook project for development.

## Prerequisites

Before you begin, ensure you have the following installed:

- **macOS** 12.0 (Monterey) or later
- **Xcode** 14.0 or later
- **Git** for version control
- **iOS Simulator** or an iOS device (iOS 15.0+)

## Step-by-Step Setup

### 1. Install Xcode

1. Download Xcode from the Mac App Store
2. Open Xcode and accept the license agreement
3. Wait for Xcode to install additional components
4. Open Xcode Preferences → Locations and ensure Command Line Tools is set

### 2. Clone the Repository

```bash
# Using HTTPS
git clone https://github.com/jb-tech1999/Logbook-SwiftUI.git

# Or using SSH
git clone git@github.com:jb-tech1999/Logbook-SwiftUI.git

# Navigate to the project directory
cd Logbook-SwiftUI
```

### 3. Open the Project

```bash
# Open the Xcode project
open Logbook.xcodeproj
```

Alternatively, you can:
- Double-click `Logbook.xcodeproj` in Finder
- Open Xcode and use File → Open → select `Logbook.xcodeproj`

### 4. Configure Development Team

1. In Xcode, select the **Logbook** project in the navigator
2. Select the **Logbook** target
3. Go to **Signing & Capabilities** tab
4. Under **Team**, select your Apple Developer account
   - If you don't see your account, click "Add Account..." and sign in
5. Xcode will automatically manage signing

### 5. Build the Project

```bash
# Using Xcode: Press Cmd + B
# Or from the menu: Product → Build
```

The first build may take a few minutes as Xcode indexes the project.

### 6. Select a Simulator or Device

1. In Xcode's toolbar, click the device selector (next to the Play/Stop buttons)
2. Choose a simulator (e.g., iPhone 14) or your connected iOS device
3. Wait for the simulator to boot if it's not already running

### 7. Run the Application

```bash
# Using Xcode: Press Cmd + R
# Or from the menu: Product → Run
```

The app will build, install, and launch on your selected device/simulator.

## Project Structure Overview

```
Logbook-SwiftUI/
├── Logbook/
│   ├── LogbookApp.swift          # App entry point
│   ├── Services/
│   │   └── Webservice.swift      # API communication
│   ├── Models/
│   │   ├── AuthViewModel.swift
│   │   ├── CarViewModel.swift
│   │   ├── LogViewModel.swift
│   │   ├── AddCarViewModel.swift
│   │   └── AddLogViewModel.swift
│   ├── Views/
│   │   ├── AuthView.swift
│   │   ├── CarsView.swift
│   │   ├── LogView.swift
│   │   ├── AddCarView.swift
│   │   └── AddLogView.swift
│   └── Assets.xcassets/
├── LogbookTests/
├── LogbookUITests/
└── README.md
```

## Configuration

### Backend URL

The backend URL is currently hardcoded in `Webservice.swift`. To change it for development:

1. Open `Logbook/Services/Webservice.swift`
2. Find all instances of `https://bellispc.ddns.net/api`
3. Replace with your development backend URL

```swift
// Example: Change this
guard let url = URL(string: "https://bellispc.ddns.net/api/login") else {
    // ...
}

// To this (for local development)
guard let url = URL(string: "http://localhost:8000/api/login") else {
    // ...
}
```

**Note:** For production, consider using a configuration file or environment variables.

### UserDefaults Keys

The app uses UserDefaults to store the authentication token:
- Key: `"authtoken"`
- To clear saved credentials during development, reset the simulator:
  ```
  Device → Erase All Content and Settings...
  ```

## Development Workflow

### Making Changes

1. **Create a new branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** in Xcode

3. **Test your changes**
   - Build and run the app (Cmd + R)
   - Test on different simulators/devices
   - Check for warnings (Cmd + B)

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

5. **Push to GitHub**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request** on GitHub

### Code Style

- Use 4 spaces for indentation
- Follow Swift naming conventions (PascalCase for types, camelCase for variables)
- Add comments for complex logic
- Use MARK comments to organize code

```swift
// MARK: - Properties

// MARK: - Lifecycle

// MARK: - Actions

// MARK: - Helper Methods
```

## Debugging

### Viewing Console Logs

- Open Debug Area: **View → Debug Area → Show Debug Area** (Cmd + Shift + Y)
- Print statements will appear in the console
- The app uses `print()` statements for debugging

### Breakpoints

1. Click on the line number in Xcode to add a breakpoint
2. Run the app in debug mode (Cmd + R)
3. When execution hits the breakpoint, use the debug controls to step through code

### Network Debugging

To inspect network requests:
1. Enable Network Link Conditioner in iOS Settings (on simulators)
2. Check the console for API response prints
3. Use Charles Proxy or similar tools for detailed request inspection

## Testing

### Running Unit Tests

```bash
# Using Xcode: Cmd + U
# Or from menu: Product → Test
```

### Running UI Tests

```bash
# Select the LogbookUITests scheme
# Press Cmd + U
```

Currently, the project has minimal tests. Contributing tests is highly appreciated!

## Common Issues and Solutions

### Issue: "No such module" error

**Solution:**
- Clean build folder: **Product → Clean Build Folder** (Cmd + Shift + K)
- Close and reopen Xcode
- Delete derived data: `~/Library/Developer/Xcode/DerivedData/`

### Issue: Code signing error

**Solution:**
- Ensure you've selected a development team in **Signing & Capabilities**
- Try using "Automatic" signing
- Check that your Apple ID is valid in Xcode Preferences → Accounts

### Issue: Simulator not launching

**Solution:**
- Restart Xcode
- Reset simulator: **Device → Erase All Content and Settings**
- Try a different simulator device

### Issue: Backend connection fails

**Solution:**
- Check network connectivity
- Verify backend URL is correct
- If using localhost, ensure backend is running
- Check simulator can reach your development machine (use machine's IP instead of localhost)

### Issue: Build takes too long

**Solution:**
- Enable parallel builds: **Product → Scheme → Edit Scheme → Build → Parallelize Build**
- Increase build active architectures: **Build Settings → Build Active Architecture Only → Yes** (for Debug)

## Useful Xcode Shortcuts

- **Cmd + B**: Build
- **Cmd + R**: Run
- **Cmd + .**: Stop
- **Cmd + U**: Run tests
- **Cmd + Shift + K**: Clean build folder
- **Cmd + Shift + O**: Quick open (search for files)
- **Cmd + Shift + J**: Reveal in Project Navigator
- **Cmd + Shift + Y**: Toggle Debug Area
- **Cmd + 0**: Toggle Navigator
- **Cmd + Option + 0**: Toggle Inspector
- **Cmd + /**: Comment/Uncomment line
- **Cmd + [** or **]**: Decrease/Increase indent

## SwiftUI Previews

SwiftUI views include preview code:

```swift
#Preview {
    CarsView()
}
```

To use live previews:
1. Open a SwiftUI file
2. Click **Resume** in the preview canvas (or press **Option + Cmd + P**)
3. Interact with the preview to see live updates

**Note:** If previews don't work, try:
- Cmd + Option + P to refresh
- Clean build folder
- Restart Xcode

## Environment Setup for API Development

If you're also working on the backend:

1. **Install Python 3.9+**
   ```bash
   brew install python@3.9
   ```

2. **Set up FastAPI backend** (see backend repository for details)

3. **Run backend locally**
   ```bash
   uvicorn main:app --reload --host 0.0.0.0 --port 8000
   ```

4. **Update Webservice.swift** to point to localhost

## Resources

### SwiftUI Documentation
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

### iOS Development
- [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios)
- [Swift Language Guide](https://docs.swift.org/swift-book/)

### Community
- [Swift Forums](https://forums.swift.org/)
- [Stack Overflow - SwiftUI](https://stackoverflow.com/questions/tagged/swiftui)

## Getting Help

If you run into issues:

1. Check this guide and the main README
2. Search existing GitHub issues
3. Ask in the project's GitHub Discussions
4. Create a new issue with:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Xcode version and iOS version
   - Relevant code snippets or screenshots

## Next Steps

After setup:

1. Familiarize yourself with the codebase
2. Review open issues on GitHub
3. Read CONTRIBUTING.md
4. Try making a small change and test it
5. Consider adding tests for new features

Happy coding! 🚀
