//
//  APIClient.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-07.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func getUser() async throws -> User
    func getUsers() async throws -> [User]
    func getConversations() async throws -> [Conversation]
    func getMessages(forConversationID id: Int) async throws -> [Message]
    func getMembers(forMembersID id: Int) async throws -> [Member]
}

extension APIClient: APIClientProtocol {}

struct APIClient {
    
    private let keychainWrapper = KeychainWrapper()
    
    let errorHandler: ErrorHandler
    
    struct Request<T: Decodable> {
        let path: String
        let method: String
        let parameters: [String: Any]?
        let token: String?
        
        init(path: String, method: String = "GET", parameters: [String : Any]? = nil, token: String? = nil) {
            self.path = path
            self.method = method
            self.parameters = parameters
            self.token = token
        }
        
        func request(with baseURL: URL) throws -> URLRequest {
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.httpMethod = method
            
            // if the token exists, set the Authorization header
            if let token = token {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            if let parameters = parameters {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                request.httpBody = jsonData
            }
            
            print("\n--- Request Details ---")
            print("URL: \(request.url?.absoluteString ?? "None")")
            print("Method: \(request.httpMethod ?? "None")")
            print("Headers: \(request.allHTTPHeaderFields ?? [:])")
            if let body = request.httpBody {
                    print("Body: \(String(data: body, encoding: .utf8) ?? "None")")
                }
            return request
        }
        
        func parseResponse(data: Data) throws -> T { // custom json decoder to parse created_at and modified_at
            let decoder = JSONDecoder()
            
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                
                if let date = dateFormatter.date(from: dateStr) {
                    return date
                }
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateStr)")
                
            }
            return try decoder.decode(T.self, from: data)
        }
    }
    
    let baseURL: URL
    
    init(baseURL: URL, errorHandler: ErrorHandler) {
        self.baseURL = baseURL
        self.errorHandler = errorHandler
    }
    
    enum NetworkError: Error { // added after commit 15/6 2023. Check whether errors need their own model or should be in another file.
        case unauthorized
  //      case invalidURL
    }
    
    func send<T: Decodable>(_ request: Request<T>) async throws -> T {
        
        let urlRequest = try request.request(with: baseURL)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print("Response: \(response)")
     //   print("Raw server data: \(String(data: data, encoding: .utf8) ?? "Not a string")")
        
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
            DispatchQueue.main.async {
            errorHandler.received401 = true
            }
            throw NetworkError.unauthorized
        }
        
        do {
            return try request.parseResponse(data: data)
        } catch let error as DecodingError {
            
            // Handle and print detailed information in case of a DecodingError
            print("DecodingError: \(error)")
            handleDecodingError(error)
            print("Error fetching members: \(error)")
            throw error
        }
    }
    
    func handleDecodingError(_ error: DecodingError) {
        
        switch error {
            
            case .dataCorrupted(let context):
                print("Data corrupted: \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found: \(context.debugDescription)")
            case .typeMismatch(let type, let context):
                print("Type mismatch: Expected type \(type): \(context.debugDescription)")
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found: \(context.debugDescription)")
            @unknown default:
                print("Unknown decoding error: \(error)")
        }
    }
    
    
    func getUser() async throws -> User { // API call to get the authenticated User.
        let path = WeavyAPIConfig.getUser
        let url = baseURL.appendingPathComponent(path)
        print("URL: \(url.absoluteString)")
        let request = Request<User>(path: path, method: "GET", parameters: nil, token: keychainWrapper.retrieveAccessToken())
        return try await send(request)
    }
    
    struct UsersResponse: Decodable {
        let data: [User]
    }
    
    func getUsers() async throws -> [User] { // API call to get the authenticated user's contacts, ie other users.
        
        let request = Request<UsersResponse>(path: WeavyAPIConfig.getUsers, method: "GET", parameters: nil, token: keychainWrapper.retrieveAccessToken())
        let response = try await send(request)
    //    print(response)
        return response.data
        
    }
    
    struct ConversationsResponse: Decodable {
        let data: [Conversation]
    }
    
    func getConversations() async throws -> [Conversation] { // API call to get the authenticated user's conversations.
        
        let request = Request<ConversationsResponse>(path: WeavyAPIConfig.getConversations,
            method: "GET",
            parameters: nil,
            token: keychainWrapper.retrieveAccessToken())
        let response = try await send(request)
        return response.data
    }
    
    struct MessagesResponse: Decodable {
        let data: [Message] 
        
    }
    
    func getMessages(forConversationID id: Int) async throws -> [Message] {
        
        let endpoint = WeavyAPIConfig.getMessages.replacingOccurrences(of: "{id}", with: "\(id)")
        print("Fetching messages from endpoint (API Client): \(endpoint)")

        let request = Request<MessagesResponse>(
            path: endpoint,
            method: "GET",
            parameters: nil,
            token: keychainWrapper.retrieveAccessToken()
        )
  
        let response = try await send(request)
        return response.data
    }
    
    struct MemberResponse: Decodable {
        let data: [Member]
    }
    
    func getMembers(forMembersID id: Int) async throws -> [Member] {
        let endpoint = WeavyAPIConfig.getMembers.replacingOccurrences(of: "{id}", with: "\(id)")
        print("Generated endpoint URL: \(endpoint)")
        print("Fetching members from endpoint: \(endpoint)")
        
        let request = Request<MemberResponse>(
            path: endpoint,
            method: "GET",
            parameters: nil,
            token: keychainWrapper.retrieveAccessToken()
        )
        let response = try await send(request)
        print("(API Client, request 2) Received response: \(response)")
        return response.data
    }
}
