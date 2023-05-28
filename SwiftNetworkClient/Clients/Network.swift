//
//  Network.swift
//  SwiftNetworkClient
//
//  Created by Ivan Starchykov on 5/28/23.
//

import Foundation

/**
 Manages network configuration and provides a method to create a URL based on the specified endpoint.
 
 The `Network` class is a singleton class that provides a shared instance to manage network-related settings and operations.
 
 Example usage:
 ```
 let network = Network.shared
 network.tunnel = "https://"
 network.server = "example.com"
 
 let url = network.createURL(endPoint: .apiEndpoint)
 ```
 
 - Note: Access the shared instance using `Network.shared`.
 
 */
final class Network {
    static let shared = Network()
    private init() {}
    
    // MARK: - Properties
    
    private var networkTunnel: String = ""
    private var networkServer: String = ""
    private var networkToken: String = ""
    
    // MARK: - Tunnel
    
    /**
     The tunnel component of the URL.
     
     The `tunnel` property represents the tunnel component of the URL used by the `Network` class. It provides a getter and a setter to access and modify the value of the tunnel.
     
     Example usage:
     ```
     let network = Network.shared
     network.tunnel = "https://"
     let tunnelValue = network.tunnel
     ```
     
     - Note: The tunnel value should be a valid URL scheme such as "http://" or "https://".
     
     */
    var tunnel: String {
        get {
            return networkTunnel
        }
        set(tunnel) {
            networkTunnel = tunnel
        }
    }
    
    // MARK: - Server
    
    /**
     The server component of the URL.
     
     The `server` property represents the server component of the URL used by the `Network` class. It provides a getter and a setter to access and modify the value of the server.
     
     Example usage:
     ```
     let network = Network.shared
     network.server = "example.com"
     let serverValue = network.server
     ```
     
     - Note: The server value should be a valid domain name or IP address.
     
     */
    var server: String {
        get {
            return networkServer
        }
        set(server) {
            networkServer = server
        }
    }
    
    // MARK: - Token
    
    /**
     The server component of the URL.
     
     The `server` property represents the server component of the URL used by the `Network` class. It provides a getter and a setter to access and modify the value of the server.
     
     Example usage:
     ```
     let network = Network.shared
     network.server = "example.com"
     let serverValue = network.server
     ```
     
     - Note: The server value should be a valid domain name or IP address.
     
     */
    var token: String {
        get {
            return networkToken
        }
        set(token) {
            networkToken = token
        }
    }
    
    // MARK: - createURL Method
    
    /**
     Creates a URL based on the specified endpoint.
     
     Use this method to generate a URL by combining the tunnel, server, and endpoint components.
     
     Example usage:
     
     ```
     let url = network.createURL(endPoint: .apiEndpoint)
     ```
     
     - Parameter endpoint: The endpoint for which to create the URL.
     
     - Returns: A URL object created by combining the tunnel, server, and endpoint components.
     
     */
    func createURL(endpoint: Endpoints) -> URL? {
        let str = networkTunnel + networkServer + endpoint.rawValue
        let url = URL(string: str)
        return url
    }
}
