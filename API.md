# API Documentation

This document describes the backend API endpoints used by the Fuel Logbook application.

## Base URL

```
https://bellispc.ddns.net/api
```

## Authentication

All endpoints except `/login` require authentication using a JWT (JSON Web Token) in the Authorization header:

```
Authorization: Bearer <token>
```

The token is obtained from the login endpoint and stored locally in UserDefaults.

---

## Endpoints

### Authentication

#### Login

**Endpoint:** `POST /login`

**Description:** Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response (Success - 200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "detail": null
}
```

**Response (Error - 401):**
```json
{
  "token": null,
  "detail": "Invalid credentials"
}
```

**Example:**
```swift
Webservice().login(username: "user@example.com", password: "password123") { result in
    switch result {
    case .success(let token):
        // Store token and proceed
        print("Token: \(token)")
    case .failure(let error):
        // Handle error
        print("Login failed: \(error)")
    }
}
```

---

### Vehicle Management

#### Get All Vehicles

**Endpoint:** `GET /cars`

**Description:** Retrieves all vehicles registered to the authenticated user.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (Success - 200):**
```json
[
  {
    "model": "Corolla",
    "year": 2020,
    "registration": "ABC123",
    "make": "Toyota",
    "user_id": 1
  },
  {
    "model": "Civic",
    "year": 2019,
    "registration": "XYZ789",
    "make": "Honda",
    "user_id": 1
  }
]
```

**Example:**
```swift
Webservice().getCars(token: authToken) { result in
    switch result {
    case .success(let cars):
        // Process cars array
        print("Found \(cars.count) vehicles")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

#### Add Vehicle

**Endpoint:** `POST /addcar`

**Description:** Adds a new vehicle for the authenticated user.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "registration": "ABC123",
  "make": "Toyota",
  "model": "Corolla",
  "year": 2020
}
```

**Response (Success - 200/201):**
```json
{
  "message": "Vehicle added successfully"
}
```

**Example:**
```swift
Webservice().addCar(token: authToken, registration: "ABC123", 
                    make: "Toyota", model: "Corolla", year: 2020) { result in
    switch result {
    case .success(let message):
        print("Success: \(message)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

#### Delete Vehicle

**Endpoint:** `DELETE /deletecar/{registration}`

**Description:** Deletes a vehicle by its registration number.

**Headers:**
```
Authorization: Bearer <token>
```

**Path Parameters:**
- `registration` (string): Vehicle registration/license plate number

**Response (Success - 200):**
```json
{
  "message": "Vehicle deleted successfully"
}
```

**Example:**
```swift
Webservice().deleteCar(token: authToken, registration: "ABC123") { result in
    switch result {
    case .success(let message):
        print("Deleted: \(message)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

---

### Fuel Log Management

#### Get Vehicle Logs

**Endpoint:** `GET /logs/{registration}`

**Description:** Retrieves all fuel logs for a specific vehicle.

**Headers:**
```
Authorization: Bearer <token>
```

**Path Parameters:**
- `registration` (string): Vehicle registration/license plate number

**Response (Success - 200):**
```json
[
  {
    "logid": 1,
    "user_id": 1,
    "carRegistration": "ABC123",
    "date": "2024-03-15",
    "odometer": 50000,
    "distance": 450.5,
    "litersPurchase": 40.0,
    "garage": "Shell Station",
    "totalcost": 1200.00
  },
  {
    "logid": 2,
    "user_id": 1,
    "carRegistration": "ABC123",
    "date": "2024-03-08",
    "odometer": 49550,
    "distance": 425.0,
    "litersPurchase": 38.5,
    "garage": "BP Station",
    "totalcost": 1150.00
  }
]
```

**Example:**
```swift
Webservice().getLogs(token: authToken, registration: "ABC123") { result in
    switch result {
    case .success(let logs):
        print("Found \(logs.count) logs")
        for log in logs {
            let economy = log.distance / log.litersPurchase
            print("Fuel economy: \(economy) km/L")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

#### Add Fuel Log

**Endpoint:** `POST /addlog`

**Description:** Adds a new fuel log entry for a vehicle.

**Headers:**
```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "carRegistration": "ABC123",
  "date": "2024-03-15",
  "odometer": 50000,
  "distance": 450.5,
  "totalcost": 1200.00,
  "garage": "Shell Station",
  "litersPurchase": 40.0
}
```

**Field Descriptions:**
- `carRegistration`: Vehicle registration/license plate number
- `date`: Date in `yyyy-MM-dd` format
- `odometer`: Current odometer/speedometer reading (in km)
- `distance`: Distance traveled since last fill-up (in km)
- `totalcost`: Total cost of fuel purchase (in local currency)
- `garage`: Name of gas station/garage
- `litersPurchase`: Amount of fuel purchased (in liters)

**Response (Success - 200/201):**
```json
{
  "message": "Log added successfully"
}
```

**Example:**
```swift
Webservice().addLog(
    token: authToken,
    carRegistration: "ABC123",
    date: "2024-03-15",
    odometer: 50000,
    distance: 450.5,
    totalcost: 1200.00,
    garage: "Shell Station",
    litersPurchase: 40.0
) { result in
    switch result {
    case .success(let message):
        print("Success: \(message)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

---

## Error Responses

All endpoints may return the following error responses:

### 401 Unauthorized
```json
{
  "detail": "Could not validate credentials"
}
```

### 400 Bad Request
```json
{
  "detail": "Invalid request data"
}
```

### 404 Not Found
```json
{
  "detail": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "detail": "Internal server error"
}
```

---

## Data Models

### User
```swift
struct User: Codable {
    let username: String
    let password: String
}
```

### Car
```swift
struct Car: Decodable {
    let model: String
    let year: Int
    let registration: String
    let make: String
    let user_id: Int
}
```

### LogResponse
```swift
struct LogResponse: Decodable {
    let logid: Int?
    let user_id: Int
    let carRegistration: String?
    let date: String
    let odometer: Int
    let distance: Double
    let litersPurchase: Double
    let garage: String
    let totalcost: Double
}
```

---

## Rate Limiting

Currently, there are no explicit rate limits enforced. However, it's recommended to:
- Implement local caching to reduce API calls
- Batch requests when possible
- Handle network errors gracefully with retry logic

---

## Backend Technology

The backend is built with:
- **Framework:** FastAPI (Python)
- **Authentication:** JWT (JSON Web Tokens)
- **Database:** PostgreSQL/MySQL (exact database not specified)
- **Hosting:** Custom server at bellispc.ddns.net

---

## Future API Enhancements

Planned improvements to the API:

1. **Pagination** for log listings when data grows large
2. **Filtering** by date range, cost range, etc.
3. **Statistics endpoints** for aggregated data
4. **Batch operations** for adding multiple logs
5. **Photo upload** for receipts
6. **Maintenance tracking** endpoints
7. **Search functionality** across logs
8. **Data export** endpoints (CSV, PDF)

---

## Security Considerations

1. **Always use HTTPS** - The API uses HTTPS to encrypt data in transit
2. **Token Storage** - Store JWT tokens securely using iOS Keychain (currently uses UserDefaults)
3. **Token Expiry** - Implement token refresh mechanism when tokens expire
4. **Input Validation** - All user input should be validated before sending to API
5. **Error Handling** - Don't expose sensitive error details to users

---

## Testing the API

You can test the API using tools like:

### cURL Example
```bash
# Login
curl -X POST https://bellispc.ddns.net/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user@example.com","password":"password123"}'

# Get Cars (with token)
curl -X GET https://bellispc.ddns.net/api/cars \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Postman Collection
Import these endpoints into Postman for easier testing and development.

---

## Support

For API issues or questions:
- Check the backend logs for detailed error messages
- Contact the backend administrator
- Open an issue on the GitHub repository
