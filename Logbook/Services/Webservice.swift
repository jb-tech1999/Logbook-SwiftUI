//
//  Webservice.swift
//  Logbook
//
//  Created by Jandre Badenhorst on 2024/03/05.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct User: Codable {
    let username: String
    let password: String
}

struct LoginReponse: Codable {
    let token : String?
    let detail: String?
    
}

struct newCar: Codable {
    let registration: String
    let make: String
    let model: String
    let year : Int
}


struct newLog: Codable {
    let carRegistration: String?
    let date: String?
    let odometer: Int?
    let distance: Double?
    let totalcost: Double?
    let garage: String?
    let litersPurchase: Double?
}

enum AddLogError: Error {
    case encodeError
    case invalidURL
    case custom(errorMessage: String)
    case decodingError
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

struct Car: Decodable {
    let model: String
    let year: Int
    let registration: String
    let make: String
    let user_id: Int
}

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

struct DeleteMessage: Decodable {
    let message: String
}


class Webservice {
    
    
    
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
    
    //    struct newLog: Codable {
    //        let carRegistration: String
    //        let date: String
    //        let odometer: Int
    //        let distance: Double
    //        let totalcost: Double
    //        let garage: String
    //        let litersPurchase: Double
    //    }
    
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
            guard let logs = try? JSONDecoder().decode([LogResponse].self, from: data) else {
                completion(.failure(.decodingError))
                print("Decoding Error")
                print(data)
                return
            }
            completion(.success("OK"))
            
            
        }.resume()
        
    }
    
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

