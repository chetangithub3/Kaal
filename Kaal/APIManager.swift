    //
    //  APIManager.swift
    //  Kaal
    //
    //  Created by Chetan Dhowlaghar on 12/5/23.
    //

import Foundation
import Combine


enum APIError: Error {
    case notFound
    case badServer
    case unhandled(Error)
}

protocol APIManagerDelegate {
    func publisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error>
}

public struct APIManager: APIManagerDelegate {
    static let shared = APIManager()
    private let errorSubject = PassthroughSubject<APIError, Never>()
    
    func publisher<T: Decodable>(for url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                
                guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
                    throw URLError(URLError.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> APIError in
                            if let urlError = error as? URLError {
                                switch urlError.code {
                                    case .badServerResponse:
                                    self.errorSubject.send(.badServer)
                                    return .badServer
                                default:
                                    return .unhandled(urlError)
                                }
                            } else {
                                return .unhandled(error)
                            }
                        }
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    func observeErrors() -> AnyPublisher<APIError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
}
