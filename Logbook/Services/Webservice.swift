//
//  Webservice.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import Foundation

// MARK: - Error Types

/// Errors that can occur during authentication
enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

/// Errors that can occur when adding logs or cars
enum AddLogError: Error {
    case encodeError
    case invalidURL
    case custom(errorMessage: String)
    case decodingError
}

/// General network communication errors
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

// MARK: - Request Models

/// User credentials for authentication
struct User: Codable {
    let username: String
    let password: String
}

/// Request model for creating a new car
struct newCar: Codable {
    let registration: String
    let make: String
    let model: String
    let year : Int
}

/// Request model for creating a new fuel log entry
struct newLog: Codable {
    let carRegistration: String?
    let date: String?
    let odometer: Int?
    let distance: Double?
    let totalcost: Double?
    let garage: String?
    let litersPurchase: Double?
}

// MARK: - Response Models

/// Response from login endpoint containing JWT token
struct LoginReponse: Codable {
    let token : String?
    let detail: String?
}

/// Vehicle information returned from API
struct Car: Decodable {
    let model: String
    let year: Int
    let registration: String
    let make: String
    let user_id: Int
}

/// Fuel log entry returned from API
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

/// Generic delete operation response
struct DeleteMessage: Decodable {
    let message: String
}

// MARK: - Webservice

/// Service class for all API communication with the backend
/// Handles authentication, vehicle management, and fuel log operations
class Webservice {
    
    // MARK: - Fuel Log Management
    
    /// Retrieves all fuel logs for a specific vehicle
    /// - Parameters:
    ///   - token: JWT authentication token
    ///   - registration: Vehicle registration/license plate number
    ///   - completion: Completion handler with Result containing array of LogResponse objects or NetworkError
    func getLogs(token: String, registration: String, completion: @escaping (Result<[LogResponse], NetworkError>) -> Void) {
        guard let url = URL(string: "https://bellispc.ddns.net/api/logs/\(registration)") else {
            completion(.failure(.invalidURL))
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { ( data, reponse, error) in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                print("no data")
                return
            }
            
            guard let logs = try? JSONDecoder().decode([LogResponse].self, from: data) else {
                completion(.failure(.decodingError))
                print("Decoding Error")
                print(data)
                return
            }
            completion(.success(logs))
            print(logs)
            
        }.resume()
        
    }
    
    // MARK: - Vehicle Management
    
    /// Retrieves all vehicles for the authenticated user
    /// - Parameters:
    ///   - token: JWT authentication token
    ///   - completion: Completion handler with Result containing array of Car objects or NetworkError
    func getCars(token: String, completion: @escaping (Result<[Car], NetworkError>) -> Void) {
        guard let url = URL(string: "https://bellispc.ddns.net/api/cars") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { ( data, reponse, error) in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let cars = try? JSONDecoder().decode([Car].self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            completion(.success(cars))
            //print(cars)
            
        }.resume()
        
    }
    
    // MARK: - Authentication
    
    /// Authenticates a user with username and password
    /// - Parameters:
    ///   - username: User's username
    ///   - password: User's password
    ///   - completion: Completion handler with Result containing JWT token or AuthenticationError
    func login (username: String, password: String, completion: @escaping(Result<String, AuthenticationError>) -> Void)  {
        
        guard let url = URL(string : "https://bellispc.ddns.net/api/login") else {
            completion(.failure(.custom(errorMessage: "URL is not correct")))
            return
        }
        let body = User(username: username, password: password)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No Data")))
                return
            }
            
            guard let loginReponse = try? JSONDecoder().decode(LoginReponse.self, from: data) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            guard let token = loginReponse.token else {
                completion(.failure(.invalidCredentials))
                return
            }
            completion(.success(token))
            
        }.resume()
        
    }
    
    /// Adds a new fuel log entry for a vehicle
    /// - Parameters:
    ///   - token: JWT authentication token
    ///   - carRegistration: Vehicle registration/license plate number
    ///   - date: Date of fuel purchase in yyyy-MM-dd format
    ///   - odometer: Odometer/speedometer reading at time of purchase
    ///   - distance: Distance traveled since last fill-up in kilometers
    ///   - totalcost: Total cost of fuel purchase
    ///   - garage: Name of gas station/garage
    ///   - litersPurchase: Amount of fuel purchased in liters
    ///   - completion: Completion handler with Result containing success message or AddLogError
    func addLog(token: String, carRegistration: String, date: String, odometer: Int, distance: Double, totalcost: Double, garage: String, litersPurchase: Double, completion: @escaping(Result<String, AddLogError>) -> Void) {
        guard let url = URL(string : "https://bellispc.ddns.net/api/addlog") else {
            completion(.failure(.invalidURL))
            return
        }
        let body = newLog(carRegistration: carRegistration, date: date, odometer: odometer, distance: distance, totalcost: totalcost, garage: garage, litersPurchase: litersPurchase)
        print(body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No Data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Handle cases where the response is not an HTTP response
                completion(.failure(.custom(errorMessage: "Invalid response")))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                // Successful status code (e.g., 200 OK)
                completion(.success("OK"))
            }
//            guard let logs = try? JSONDecoder().decode([LogResponse].self, from: data) else {
//                completion(.failure(.decodingError))
//                print("Decoding Error")
//                print(data)
//                return
//            }
//            completion(.success("OK"))
            
            
        }.resume()
        
    }
    
    /// Adds a new vehicle for the authenticated user
    /// - Parameters:
    ///   - token: JWT authentication token
    ///   - registration: Vehicle registration/license plate number
    ///   - make: Vehicle manufacturer (e.g., Toyota, Ford)
    ///   - model: Vehicle model (e.g., Corolla, F-150)
    ///   - year: Year of manufacture
    ///   - completion: Completion handler with Result containing success message or AddLogError
    func addCar(token: String, registration: String, make: String, model: String, year: Int , completion: @escaping(Result<String, AddLogError>) -> Void) {
        guard let url = URL(string : "https://bellispc.ddns.net/api/addcar") else {
            completion(.failure(.invalidURL))
            return
        }
        let body = newCar(registration: registration, make: make, model: model, year: year)
        print(body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No Data")))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Handle cases where the response is not an HTTP response
                completion(.failure(.custom(errorMessage: "Invalid response")))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                // Successful status code (e.g., 200 OK)
                completion(.success("OK"))
            }
            //            guard let cars = try? JSONDecoder().decode([Car].self, from: data) else {
            //                completion(.failure(.decodingError))
            //                print("Decoding Error")
            //                print(data)
            //                return
            //            }
            //            completion(.success("OK"))
            
            
        }.resume()
        
    }
    
    /// Deletes a vehicle by registration number
    /// - Parameters:
    ///   - token: JWT authentication token
    ///   - registration: Vehicle registration/license plate number to delete
    ///   - completion: Completion handler with Result containing success message or AddLogError
    func deleteCar(token: String, registration: String, completion: @escaping(Result<String, AddLogError>) -> Void) {
        guard let url = URL(string : "https://bellispc.ddns.net/api/deletecar/\(registration)") else {
            completion(.failure(.invalidURL))
            return
        }
        print(url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { ( data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(.custom(errorMessage: "No Data")))
                return
            }
            
            guard  error == nil else {
                print(error!)
                return
            }
            
            guard let message = try? JSONDecoder().decode(DeleteMessage.self, from: data) else {
                completion(.failure(.decodingError))
                print("Decoding Error")
                return
            }
            print(message)
            completion(.success("OK"))
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Handle cases where the response is not an HTTP response
                completion(.failure(.custom(errorMessage: "Invalid response")))
                return
            }
            
            if 200..<300 ~= httpResponse.statusCode {
                // Successful status code (e.g., 200 OK)
                completion(.success("OK"))
            }
        }.resume()
        
    }
}

