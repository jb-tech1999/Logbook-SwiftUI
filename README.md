# Fuel Logbook - SwiftUI

A modern iOS application for tracking vehicle fuel consumption, maintenance logs, and analyzing fuel economy. Built with SwiftUI and integrated with a custom FastAPI backend.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [API Integration](#api-integration)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [Known Issues](#known-issues)
- [Future Enhancements](#future-enhancements)

## Overview

This project was created to digitize and simplify the process of tracking vehicle travel logs and fuel consumption. Instead of manually writing down fuel purchases and mileage in a physical logbook, this app provides a convenient digital solution for iOS devices.

The application uses SwiftUI for the user interface and connects to a custom FastAPI backend for data persistence and synchronization across devices.

## Features

### Authentication
- Secure user login with token-based authentication
- Persistent session management using UserDefaults
- Auto-login for returning users

### Vehicle Management
- Add multiple vehicles with details (make, model, registration, year)
- View all registered vehicles
- Delete vehicles with swipe-to-delete gesture
- Detailed vehicle information view

### Fuel Log Management
- Record fuel purchases with comprehensive details:
  - Date of purchase
  - Odometer reading
  - Distance traveled
  - Fuel amount (liters)
  - Total cost
  - Garage/station name
- View logs sorted by date (most recent first)
- Automatic fuel economy calculation (km/L)
- Filter logs by vehicle
- Detailed log view with all information

### Statistics (Planned)
- Placeholder view for future analytics features
- Fuel economy trends
- Cost analysis over time

## Architecture

The app follows the MVVM (Model-View-ViewModel) architecture pattern:

### Views
- `AuthView`: User authentication interface
- `MainView`: Tab-based navigation container
- `CarsView`: Vehicle list and management
- `LogView`: Fuel log list and filtering
- `AddCarView`: Form for adding new vehicles
- `AddLogView`: Form for adding new fuel logs
- `StatsView`: Statistics dashboard (placeholder)

### ViewModels
- `AuthViewModel`: Handles authentication logic
- `CarListViewModel` & `carViewModel`: Vehicle data management
- `LogListViewModel` & `LogViewModel`: Log data management
- `addLogViewModel`: New log creation logic
- `AddCarViewModel`: New vehicle creation logic

### Services
- `Webservice`: API communication layer with backend
  - User authentication
  - CRUD operations for vehicles
  - CRUD operations for fuel logs

### Models
- `User`: User credentials structure
- `Car`: Vehicle data model
- `LogResponse`: Fuel log data model
- Various API request/response structures

## Requirements

- iOS 15.0 or later
- Xcode 14.0 or later
- Swift 5.7 or later
- Active internet connection for backend communication

## Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/jb-tech1999/Logbook-SwiftUI.git
   cd Logbook-SwiftUI
   ```

2. **Open in Xcode**
   ```bash
   open Logbook.xcodeproj
   ```

3. **Configure Backend URL**
   
   The backend URL is currently hardcoded in `Webservice.swift`. Update the base URL if needed:
   ```swift
   // In Webservice.swift
   guard let url = URL(string: "https://bellispc.ddns.net/api/...") else {
       // Update to your backend URL
   }
   ```

4. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## Usage

### First Time Setup

1. **Login**
   - Launch the app
   - Enter your username and password
   - Tap "Sign in"
   - Your authentication token will be saved for future sessions

2. **Add Your First Vehicle**
   - Navigate to the "Cars" tab
   - Tap the pencil icon in the top right
   - Fill in vehicle details:
     - Make (e.g., Toyota)
     - Model (e.g., Corolla)
     - Registration number
     - Year
   - Tap "Add car"

3. **Record Your First Fuel Log**
   - Navigate to the "Logs" tab
   - Select a vehicle from the segmented picker
   - Tap the pencil icon in the top right
   - Fill in log details:
     - Date
     - Odometer reading
     - Distance traveled since last fill-up
     - Garage name
     - Total cost
     - Liters purchased
   - Tap "Add Log"

### Daily Usage

1. **Viewing Logs**
   - Select a vehicle in the "Logs" tab
   - Logs are sorted by date (newest first)
   - Tap any log to see detailed information including calculated fuel economy

2. **Managing Vehicles**
   - View all vehicles in the "Cars" tab
   - Tap a vehicle to see details
   - Swipe left on a vehicle to delete it

## API Integration

The app communicates with a custom FastAPI backend hosted at `bellispc.ddns.net`. 

### Endpoints Used

#### Authentication
- `POST /token` - User login, returns JWT token

#### Vehicles
- `GET /api/cars` - Retrieve all user vehicles
- `POST /api/cars` - Add a new vehicle
- `DELETE /api/cars/{registration}` - Delete a vehicle

#### Fuel Logs
- `GET /api/logs/{registration}` - Get logs for a specific vehicle
- `POST /api/logs` - Add a new fuel log
- `DELETE /api/logs/{logid}` - Delete a log

### Authentication Flow

1. User credentials are sent to `/token` endpoint
2. Backend returns a JWT token
3. Token is stored in UserDefaults with key `"authtoken"`
4. Token is included in all subsequent requests via Authorization header: `Bearer {token}`

## Project Structure

```
Logbook-SwiftUI/
├── Logbook/
│   ├── LogbookApp.swift          # App entry point
│   ├── MainView.swift            # Main tab container
│   ├── ContentView.swift         # Default SwiftUI view (unused)
│   ├── AppState.swift            # App state management
│   ├── Authenitcate.swift        # Authentication state helper
│   ├── Services/
│   │   └── Webservice.swift      # API communication layer
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
│   │   ├── AddLogView.swift
│   │   ├── LocationView.swift
│   │   └── StatsView.swift
│   └── Assets.xcassets/          # App icons and images
├── LogbookTests/                 # Unit tests
├── LogbookUITests/               # UI tests
└── README.md                     # This file
```

## Documentation

This project includes comprehensive documentation to help you understand and contribute to the codebase:

- **[DOCS_INDEX.md](DOCS_INDEX.md)** - Complete documentation index and navigation guide
- **[README.md](README.md)** (this file) - Project overview and quick start guide
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Detailed architecture and design patterns documentation
- **[API.md](API.md)** - Complete API endpoint documentation with examples
- **[SETUP.md](SETUP.md)** - Step-by-step development environment setup guide
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Guidelines for contributing to the project
- **[CHANGELOG.md](CHANGELOG.md)** - Version history and release notes

> 📚 **New to the project?** Start with [DOCS_INDEX.md](DOCS_INDEX.md) for a guided tour of all documentation.

## Contributing

Contributions are welcome! Please follow these steps:

1. Read the [Contributing Guidelines](CONTRIBUTING.md)
2. Review the [Architecture Documentation](ARCHITECTURE.md)
3. Follow the [Setup Guide](SETUP.md) to get started
4. Create a feature branch
5. Make your changes
6. Submit a pull request

For more details, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Known Issues

- Stats view is currently a placeholder with no implementation
- Backend URL is hardcoded and needs to be configurable
- Limited error handling and user feedback for network failures
- No offline mode - requires active internet connection
- Some SwiftUI best practices may not be followed due to learning curve

## Future Enhancements

- [ ] Implement comprehensive statistics and analytics
- [ ] Add charts for fuel economy trends
- [ ] Implement offline mode with local data caching
- [ ] Add data export functionality (CSV, PDF)
- [ ] Implement push notifications for maintenance reminders
- [ ] Add support for multiple fuel types
- [ ] Implement service/maintenance tracking
- [ ] Add photo attachment for receipts
- [ ] Implement map view for garage locations
- [ ] Add dark mode support
- [ ] Localization for multiple languages
- [ ] Widget support for quick log entry
- [ ] Apple Watch companion app

## Backend

The backend is currently hosted on private servers and is built with FastAPI. The backend handles:
- User authentication and authorization
- Data persistence in a database
- RESTful API endpoints for all CRUD operations

For backend setup and documentation, please contact the project maintainer.

## License

This project is currently unlicensed. Please contact the author for usage permissions.

## Author

Created by Jandre Badenhorst (2024)

## Support

For issues, questions, or suggestions, please open an issue on the GitHub repository.
