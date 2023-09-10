//
//  NetworkManager.swift
//  HelloDevice
//
//  Created by Yulia Kornichuk on 10/09/2023.
//

import Foundation

protocol NetworkManagerProtocol {
  func fetchDevices(page: Int, perPage: Int) async -> Result<[Device], NetworkError>
}

enum NetworkError: Error {
  case badEndpoint
  case badResponse(URLResponse)
  case requestFailed(Error)
}

class NetworkManager {
  
  static let sharedInstance: NetworkManager = {
    return NetworkManager()
  }()
  
  private let baseUrl: String = "https://hiring.iverify.io/api/devices"
  private let urlSession: URLSession
  private var authToken: String = {
    return SecurityManager.token
  }()
  
  private init() {
    self.urlSession = URLSession(configuration: URLSessionConfiguration.default)
  }
  
  func fetchDevices(page: Int, pageSize: Int) async -> Result<[Device], Error> {
    var urlComponents = URLComponents(string: baseUrl)
    urlComponents?.queryItems = [
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "pageSize", value: String(pageSize))
    ]
    
    guard let url = urlComponents?.url else {
      return .failure(NetworkError.badEndpoint)
    }
    
    var request = URLRequest(url: url.absoluteURL)
    request.httpMethod = "GET"
    request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
    
    do {
      let (data, response) = try await urlSession.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        return .failure(NetworkError.badResponse(response))
      }
      
      if httpResponse.statusCode == 200 {
        let devices = try JSONDecoder().decode(DevicesResult.self, from: data)
        return .success(devices.devices)
      } else {
        return .failure(NetworkError.badResponse(httpResponse))
      }
    } catch {
      return .failure(NetworkError.requestFailed(error))
    }
  }
  
}
