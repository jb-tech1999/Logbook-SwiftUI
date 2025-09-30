# Architecture Documentation

This document describes the architecture and design patterns used in the Fuel Logbook application.

## Table of Contents
- [Architecture Overview](#architecture-overview)
- [MVVM Pattern](#mvvm-pattern)
- [Data Flow](#data-flow)
- [Project Layers](#project-layers)
- [Design Patterns](#design-patterns)
- [State Management](#state-management)
- [Navigation](#navigation)
- [Network Layer](#network-layer)
- [Data Persistence](#data-persistence)

## Architecture Overview

The Fuel Logbook application follows the **MVVM (Model-View-ViewModel)** architecture pattern, which is well-suited for SwiftUI applications. This separation of concerns makes the code more maintainable, testable, and scalable.

```
┌─────────────────────────────────────────────┐
│                   View Layer                 │
│  (SwiftUI Views - User Interface)           │
│  AuthView, CarsView, LogView, etc.          │
└──────────────────┬──────────────────────────┘
                   │ User Actions
                   │ State Updates
┌──────────────────▼──────────────────────────┐
│              ViewModel Layer                 │
│  (Business Logic & State Management)        │
│  AuthViewModel, CarListViewModel, etc.      │
└──────────────────┬──────────────────────────┘
                   │ API Calls
                   │ Data Processing
┌──────────────────▼──────────────────────────┐
│               Service Layer                  │
│  (Network & Backend Communication)          │
│  Webservice                                 │
└──────────────────┬──────────────────────────┘
                   │ HTTP Requests
                   │ JSON Data
┌──────────────────▼──────────────────────────┐
│              Backend API                     │
│  (FastAPI Server)                           │
│  Authentication, CRUD Operations            │
└─────────────────────────────────────────────┘
```

## MVVM Pattern

### Model
- **Purpose**: Represents the data structure
- **Location**: Defined in `Webservice.swift` and ViewModel files
- **Examples**: `Car`, `LogResponse`, `User`
- **Characteristics**:
  - Simple data structures
  - Conform to `Codable` for JSON encoding/decoding
  - No business logic

```swift
struct Car: Decodable {
    let model: String
    let year: Int
    let registration: String
    let make: String
    let user_id: Int
}
```

### View
- **Purpose**: Displays UI and captures user input
- **Location**: `Logbook/Views/` directory
- **Examples**: `CarsView`, `LogView`, `AddCarView`
- **Characteristics**:
  - SwiftUI views
  - Observes ViewModel state using `@ObservedObject` or `@StateObject`
  - No business logic
  - Declarative UI

```swift
struct CarsView: View {
    @ObservedObject var carListVM = CarListViewModel()
    
    var body: some View {
        // UI code
    }
}
```

### ViewModel
- **Purpose**: Manages view state and business logic
- **Location**: `Logbook/Models/` directory
- **Examples**: `CarListViewModel`, `AuthViewModel`, `LogListViewModel`
- **Characteristics**:
  - Conforms to `ObservableObject`
  - Uses `@Published` properties to notify views of changes
  - Handles API calls through service layer
  - Transforms data for view consumption

```swift
class CarListViewModel: ObservableObject {
    @Published var cars: [carViewModel] = []
    
    func getAllCars() {
        // API call through Webservice
    }
}
```

## Data Flow

### User Action Flow
```
1. User interacts with View (tap, input, etc.)
2. View calls ViewModel method
3. ViewModel processes request
4. ViewModel calls Service layer (Webservice)
5. Service makes HTTP request to Backend
6. Backend processes and returns data
7. Service parses response
8. ViewModel updates @Published properties
9. View automatically re-renders with new data
```

### Example: Adding a Vehicle

```swift
// 1. User taps "Add Car" button
Button("Add car") {
    addCarVM.saveCar()  // 2. View calls ViewModel
}

// 3. ViewModel processes request
func saveCar() {
    let token = UserDefaults.standard.string(forKey: "authtoken")
    
    // 4. ViewModel calls Service
    Webservice().addCar(token: token, registration: registration, 
                       make: make, model: model, year: year) { result in
        // 5-6. Service handles HTTP request/response
        switch result {
        case .success:
            // 8. Update published property
            DispatchQueue.main.async {
                self.isAdded = true  // 9. View re-renders
            }
        case .failure(let error):
            print(error)
        }
    }
}
```

## Project Layers

### 1. Presentation Layer (Views)
**Responsibility**: User interface and user interaction

**Files**:
- `AuthView.swift` - Login screen
- `MainView.swift` - Tab navigation container
- `CarsView.swift` - Vehicle list and management
- `LogView.swift` - Fuel log list and filtering
- `AddCarView.swift` - New vehicle form
- `AddLogView.swift` - New log entry form
- `StatsView.swift` - Statistics dashboard

**Key Characteristics**:
- Pure SwiftUI views
- No direct API calls
- Minimal logic (only UI logic)
- Uses `@ObservedObject` to react to ViewModel changes

### 2. Business Logic Layer (ViewModels)
**Responsibility**: Application logic and state management

**Files**:
- `AuthViewModel.swift` - Authentication logic
- `CarViewModel.swift` - Vehicle data management
- `LogViewModel.swift` - Log data management
- `AddCarViewModel.swift` - New vehicle creation
- `AddLogViewModel.swift` - New log creation

**Key Characteristics**:
- Conform to `ObservableObject`
- Contain `@Published` properties
- Handle data transformation
- Coordinate between Views and Services

### 3. Service Layer
**Responsibility**: Backend communication

**Files**:
- `Webservice.swift` - All API endpoints

**Key Characteristics**:
- Handles HTTP requests
- Manages authentication headers
- Parses JSON responses
- Error handling
- Returns data via completion handlers

### 4. Data Layer (Models)
**Responsibility**: Data structure definitions

**Defined in**: `Webservice.swift` and ViewModel files

**Key Characteristics**:
- Conform to `Codable` for JSON serialization
- Simple structs with no behavior
- Mirror backend data structures

## Design Patterns

### 1. Observer Pattern
**Implementation**: SwiftUI's `@Published` and `ObservableObject`

```swift
class CarListViewModel: ObservableObject {
    @Published var cars: [carViewModel] = []  // Observable property
}

struct CarsView: View {
    @ObservedObject var carListVM = CarListViewModel()  // Observer
}
```

### 2. Dependency Injection
**Implementation**: Passing dependencies through initializers or environment

```swift
struct MainView: View {
    @ObservedObject var carListVM = CarListViewModel()
    
    var body: some View {
        LogView(carListVM: carListVM)  // Inject dependency
    }
}
```

### 3. Result Type Pattern
**Implementation**: Using Swift's `Result` type for async operations

```swift
func getCars(token: String, completion: @escaping (Result<[Car], NetworkError>) -> Void) {
    // Network operation
    if success {
        completion(.success(cars))
    } else {
        completion(.failure(.noData))
    }
}
```

### 4. Completion Handler Pattern
**Implementation**: Callbacks for asynchronous operations

```swift
func login(username: String, password: String, 
          completion: @escaping(Result<String, AuthenticationError>) -> Void) {
    URLSession.shared.dataTask(with: request) { data, response, error in
        // Process and call completion
        completion(.success(token))
    }.resume()
}
```

## State Management

### Local State
**Use Case**: Component-specific state

```swift
@State private var selectedCar: carViewModel?
@State private var isShowingSheet = false
```

### Shared State (ViewModel)
**Use Case**: State shared across multiple views

```swift
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
}
```

### Persistent State
**Use Case**: Data that survives app restarts

```swift
// Currently using UserDefaults
UserDefaults.standard.setValue(token, forKey: "authtoken")

// Future: Should use Keychain for sensitive data
```

## Navigation

### Tab-Based Navigation
**Implementation**: `TabView` in `MainView.swift`

```swift
TabView {
    LogView()
        .tabItem { Label("Logs", systemImage: "list.dash") }
    CarsView()
        .tabItem { Label("Cars", systemImage: "car") }
    StatsView()
        .tabItem { Label("Stats", systemImage: "chart.bar") }
}
```

### Modal Presentation
**Implementation**: Sheets for forms

```swift
.sheet(isPresented: $carListVM.isShowingAddCarView) {
    AddCarView()
}
```

### Push Navigation
**Implementation**: NavigationLink for detail views

```swift
NavigationLink(destination: CarDetailView(carViewModel: car)) {
    HStack {
        Text(car.make)
        Text(car.model)
    }
}
```

## Network Layer

### Structure
```
Webservice (API Client)
    ├── Authentication Methods
    │   └── login()
    ├── Vehicle Management
    │   ├── getCars()
    │   ├── addCar()
    │   └── deleteCar()
    └── Log Management
        ├── getLogs()
        └── addLog()
```

### Error Handling
Multiple error types for different scenarios:

```swift
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

enum AddLogError: Error {
    case encodeError
    case invalidURL
    case custom(errorMessage: String)
    case decodingError
}
```

### Request Pattern
1. Create URL
2. Create URLRequest
3. Add headers (Content-Type, Authorization)
4. Add body (for POST/PUT)
5. Execute with URLSession
6. Parse response
7. Call completion handler

## Data Persistence

### Current Implementation: UserDefaults
**Usage**: Storing authentication token

```swift
// Save
UserDefaults.standard.setValue(token, forKey: "authtoken")

// Retrieve
let token = UserDefaults.standard.string(forKey: "authtoken")
```

**Limitations**:
- Not secure for sensitive data
- Limited storage capacity
- No complex query capabilities

### Recommended Future Improvements

#### 1. Keychain for Credentials
```swift
// Store token securely in Keychain
KeychainWrapper.standard.set(token, forKey: "authtoken")
```

#### 2. Core Data for Offline Storage
```swift
// Enable offline mode with local database
@FetchRequest(sortDescriptors: [])
var cars: FetchedResults<CarEntity>
```

#### 3. Combine for Reactive Programming
```swift
// Modern async/await pattern
func getCars() async throws -> [Car] {
    // Network call
}
```

## Code Organization Best Practices

### File Structure
```
Logbook/
├── App/
│   └── LogbookApp.swift
├── Services/
│   └── Webservice.swift
├── Models/
│   ├── ViewModels/
│   └── DataModels/
├── Views/
│   ├── Authentication/
│   ├── Cars/
│   ├── Logs/
│   └── Stats/
└── Resources/
    └── Assets.xcassets
```

### Naming Conventions
- **ViewModels**: End with `ViewModel` (e.g., `CarListViewModel`)
- **Views**: Descriptive names (e.g., `CarsView`, `AddCarView`)
- **Models**: Noun names (e.g., `Car`, `LogResponse`)
- **Services**: End with `Service` (e.g., `Webservice`, `AuthService`)

### MARK Comments
Organize code within files:

```swift
// MARK: - Properties
// MARK: - Initialization
// MARK: - Lifecycle
// MARK: - API Methods
// MARK: - Helper Methods
// MARK: - Private Methods
```

## Future Architecture Improvements

### 1. Dependency Injection Container
```swift
class DependencyContainer {
    static let shared = DependencyContainer()
    let webservice = Webservice()
}
```

### 2. Repository Pattern
```swift
protocol CarRepository {
    func getCars() async throws -> [Car]
    func addCar(_ car: Car) async throws
}

class CarRepositoryImpl: CarRepository {
    // Implementation with both API and local storage
}
```

### 3. Coordinator Pattern for Navigation
```swift
class AppCoordinator {
    func showCarDetail(car: Car)
    func showAddCar()
}
```

### 4. Use Case Layer
```swift
class GetCarsUseCase {
    let repository: CarRepository
    
    func execute() async throws -> [Car] {
        return try await repository.getCars()
    }
}
```

## Testing Strategy

### Unit Tests
- Test ViewModels independently
- Mock Webservice layer
- Test data transformations

### Integration Tests
- Test ViewModel + Service integration
- Use test backend or mock server

### UI Tests
- Test critical user flows
- Test navigation
- Test form submissions

## Performance Considerations

1. **Async Operations**: All network calls on background threads
2. **Main Thread Updates**: UI updates always on main thread
3. **List Performance**: Use `ForEach` with identifiable items
4. **Image Loading**: Consider lazy loading for images in the future
5. **Caching**: Implement caching for frequently accessed data

## Security Considerations

1. **Token Storage**: Move from UserDefaults to Keychain
2. **HTTPS**: Always use HTTPS for API calls
3. **Input Validation**: Validate user input before sending to backend
4. **Error Messages**: Don't expose sensitive info in error messages
5. **Token Refresh**: Implement token refresh mechanism

---

For more information on specific components, see:
- [API Documentation](API.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Setup Guide](SETUP.md)
