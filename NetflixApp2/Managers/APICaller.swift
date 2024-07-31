//
//  APICaller.swift
//  TheNitflex
//
//  Created by ibrahim alasl on 22/07/2024.
//
//MARK: - NETWORK CALL:
import Alamofire
import Foundation
//MARK: - This code is well explained in : https://janviarora.medium.com/urlsession-in-swift-f0f7348e37d5
//Constants to clean the code of strings
struct Constants {
    static let API_KEY = "697d439ac993538da4e3e60b54e762cd"
    static let baseURL = "https://api.themoviedb.org"
    static let YoutubeAPI_KEY = "AIzaSyDqX8axTGeNpXRiISTGL7Tya7fjKJDYi4g"
    static let YoutubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}
// Erorr handling enum
enum APIError: Error {
    case failedToGetData
}

class APICaller {
    //MARK: - Singelton: https://medium.com/@ramdhas/singleton-design-pattern-managing-shared-resources-in-ios-11fb9ade9ab0
    static let shared = APICaller()
    //MARK: Setting the init to "Private" forces the class to create a Singlton.
    private init(){ }
    
    //MARK: - Fetching DATA
    
    // @escaping is used here, because this is a background task.
    // If you write a print statemnet after the dataTask completes, i.e. after resume(), then it will execute beforehand.
    // This happens because it is time consuming task and can not be implemented on main thread.
    //@escaping captures data in memeory, what it actualy does: makes the (Result<[Title], Error>) closure outlive the function that it was called, thus we don't lose the data.
    
    //MARK: It's a Get func, since we are downloading data
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        //Get the Data from the website database
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/movie/day?api_key=\(Constants.API_KEY)") else {return}
        //MARK: URLSession.shard.dataTask returns three components:
        //Data(Actual data),
        //Response(respnse code ex."200 - 299 SUCCESS , 400 ERROR etc... ),
        //Error (what type of error)
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            //MARK: After downloading the data we Decode it and put it into our model Result[Title]
            do {
                //MARK: If this throws an error, most likely because you didn't match the property names currectly in your model
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        //MARK: Runs the function ^
        task.resume()
    }
    func getTrendingTvs(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/trending/tv/day?api_key=\(Constants.API_KEY)") else { return}
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
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
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
    func getPopular(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        AF.request(url).responseData {response in
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
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return }
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
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/discover/movie?api_key=\(Constants.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else {return }
        AF.request(url).responseData{ response in
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
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.baseURL)/3/search/movie?api_key=\(Constants.API_KEY)&query=\(query)") else {return }
        AF.request(url).responseData{ response in
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
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
        
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constants.YoutubeBaseURL)q=\(query)&key=\(Constants.YoutubeAPI_KEY)") else {return}
        AF.request(url).responseData{ response in
            switch response.result {
            case .success(let data):
                do {
                    let results = try JSONDecoder().decode(YoutubeSearchResponse.self, from: data)
                    
                    completion(.success(results.items[0]))
                    
                    
                } catch {
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}

