//
//  APIService.swift
//  AirBnbAPI
//
//  Created by YouTube on 10/22/22.
//

import Foundation

struct Response: Decodable {
    let data: [Listing]
}

struct Listing: Decodable {
    let listingName: String
}

enum NetworkError: Error {
    case invalidURL
    case invalidURLRequest
    case invalidResponse
}


class APIService: NSObject {
    
    static let shared = APIService()
    
    var baseURL = URLComponents(string: "https://www.airbnb19.p.rapidapi.com")
    
    func createURLRequest(fromURL: URL) -> URLRequest? {
        var urlRequest = URLRequest(url: fromURL)
        
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "X-Rapidapi-Key": "02ea944a42msh9419208b8b72ff2p1205bajsn5a562c23fb05",
            "X-Rapidapi-Host": "airbnb19.p.rapidapi.com"
        ]
        
        return urlRequest
    }
    
    func fetchListingsFor() async throws -> [Listing] {
        baseURL?.path = "/api/v1/searchPropertyByGEO"
        baseURL?.queryItems = [
            URLQueryItem(name: "neLat", value: "46.2301696"),
            URLQueryItem(name: "neLng", value: "82.7456683"),
            URLQueryItem(name: "swLat", value: "39.6115919"),
            URLQueryItem(name: "swLng", value: "-90.5777958"),
        ]
        
        guard let completeURL = baseURL?.url else {
            throw NetworkError.invalidURL
        }
        guard let urlRequest = createURLRequest(fromURL: completeURL) else {
            throw NetworkError.invalidURLRequest
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let url = Bundle.main.url(forResource: "MockJSON", withExtension: "json") else { throw NetworkError.invalidResponse }
        let data2 = try Data(contentsOf: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let res = try JSONDecoder().decode(Response.self, from: data)
        print(res.data)
        return res.data
    }
}

extension APIService: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        return (URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}
