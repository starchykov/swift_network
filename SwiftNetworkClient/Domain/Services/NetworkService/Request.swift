//
//  Request.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation

/**
 Represents a network request for performing HTTP operations.
 
 Use this class to construct, configure, and execute network requests.
 
 Example usage:
 ```
 do {
 let posts: [PostModel] = try await request.execute()
 // Handle the retrieved posts
 } catch {
 // Handle the error
 }
 
 let request = Request(requestType: .get, endpoint: .getAllPosts)
 request.parameters = ["id": "1"]
 ```
 
 - Note: The `Request` class is not thread-safe. It should be used from the main thread.
 
 - Important: The `execute()` method should be called from an asynchronous context (e.g., within an `async` function) to await the completion of the network request.
 
 - Remark: When setting parameters for a POST request, the parameters will be encoded as the request body. For GET requests, the parameters will be encoded as query parameters.
 
 - SeeAlso: `RequestType`, `Endpoints`
 
 */
class Request {
    
    // MARK: - Properties
    
    private var _requestType: RequestType;
    private var _apiEndpoint: Endpoints;
    private var _requestParameters: [String: String] = [:];
    
    
    // MARK:  - Initializer
    
    /**
     Initializes a network request object with the provided request type and endpoint.
     
     Use this initializer to create a `Request` object with the desired request type and endpoint.
     
     Example usage:
     ```
     let request = Request(requestType: .get, endpoint: .apiEndpoint)
     ```
     
     - Parameter requestType: The type of the network request, represented by an instance of the `RequestType` enum.
     - Parameter endpoint: The endpoint of the network request, represented by an instance of the `Endpoints` enum.
     
     - Important: Provide valid instances of `RequestType` and `Endpoints` enums when initializing a `Request` object.
     
     */
    init (requestType: RequestType, endpoint: Endpoints) {
        _requestType = requestType
        _apiEndpoint = endpoint
    }
    
    // MARK: - Type Property
    
    /**
     Represents the type of a network request.
     
     Use this property to get or set the request type for a network request.
     
     Example usage:
     ```
     let request = Request(requestType: .get, endpoint: .apiEndpoint)
     let currentType = request.type
     request.type = .post
     ```
     
     - Remark: The request type is an instance of the `RequestType` enum, which represents the HTTP request method.
     
     - Important: When setting the request type, provide an instance of the `RequestType` enum.
     
     */
    var type: RequestType {
        get {
            return _requestType
        }
        set(newRequestType) {
            _requestType = newRequestType
        }
    }
    
    
    // MARK: - Parameters Property
    
    /**
     Represents the parameters for a network request.
     
     Use this property to set or retrieve the request parameters for a network request.
     
     Example usage:
     ```
     request.parameters = ["id": "1"]
     let params = request.parameters
     ```
     
     - Remark: The request parameters are stored internally in a dictionary with string keys and string values.
     
     - Important: When setting the parameters, provide a dictionary with string keys and string values.
     
     */
    var parameters: [String: String] {
        get {
            return _requestParameters
        }
        set(requestParameter) {
            _requestParameters[requestParameter.keys.first!] = requestParameter.values.first
        }
    }
    
    
    // MARK: - Execute Method
    
    /**
     Executes the network request and decodes the response data into an array of the specified type.
     
     Use this method to perform a network request and retrieve the response data as an array of the desired type.
     
     Example usage:
     ```
     let request = Request(requestType: .get, endpoint: .apiEndpoint)
     let posts: [PostModel] = try await request.execute()
     ```
     
     - Returns: An array of the specified type, obtained by decoding the response data.
     
     - Throws: An error of type `NetworkErrors` if the network request or data decoding fails.
     
     */
    func execute<T: Decodable>() async throws -> [T] {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder();
        
        // Make Request URL address, based on Network configurations.
        guard let url = Network.shared.createURL(endpoint: _apiEndpoint) else { throw NetworkErrors.error }
        
        var request = URLRequest(url: url)
        
        // Set request type and request headers.
        request.httpMethod = _requestType.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-type")
        request.url?.append(queryItems: [URLQueryItem(name: "t", value: Network.shared.token)])
        
        do {
            
            // Put additional request parameters if Request type is POST, PUT or DELETE.
            if (_requestType == RequestType.post) {
                let body = try encoder.encode(_requestParameters)
                request.httpBody = body
            } else if (_requestType == RequestType.get) {
                let queryItems: [URLQueryItem] = _requestParameters.map{(key, value) in URLQueryItem(name: key, value: value)};
                request.url?.append(queryItems: queryItems)
            }
                        
            // Define response type.
            var response: (Data, URLResponse);
            
            // Perform the asynchronous network request.
            response = try await URLSession.shared.data(for: request)
            
            let data = response.0
            
            // Decode the response data into an array of the specified type.
            let result = try decoder.decode([T].self, from: data)
            return result;
            
        } catch { throw NetworkErrors.error }
    }
    
    
}

/**
 Represents the type of an HTTP request.
 
 Use this enum to specify the desired HTTP request method for a network request.
 
 Example usage:
 let request = Request(requestType: .post, endpoint: .createUser)
 
 Note: The raw value of each enum case corresponds to the HTTP request method as a string.
 
 - Remark: The supported request types are `.post` and `.get`.
 
 */
enum RequestType: String {
    case post = "POST"
    case get = "GET"
}
