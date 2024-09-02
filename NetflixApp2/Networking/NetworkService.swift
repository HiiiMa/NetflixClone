//
//  NetworkService.swift
//  NetflixApp2
//
//  Created by ibrahim alasl on 01/09/2024.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func fetchMovies(route: EventRouter) async -> [Title]
}

class BaseNetworkService<Router: URLRequestConvertible> {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func request(router: Router, completion: @escaping (Result<[Title], Error>) -> Void) {
        var url: URL
        do {
            try url = router.makeURLRequest()
        } catch APIErrorr.invalidURL(let errorMessage) {
            print(errorMessage)
            return
        } catch {
            print("Unknown Error")
            return
        }
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                    completion(.success(results.results))
                } catch {
                    completion(.failure(APIError.failedToGetData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

class NetworkService: BaseNetworkService<EventRouter>, NetworkServiceProtocol {
    func fetchMovies(route: EventRouter) async -> [Title] {
       // Perform the asynchronous request (you will likely use URLSession or some other async API)
        do{
            return try await withCheckedThrowingContinuation { continuation in
                // This is your existing network call with a completion handler
                request(router: route) { result in
                    switch result {
                    case .success(let titles):
                        continuation.resume(returning: titles)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }catch {
            return []
        }
    }
}
