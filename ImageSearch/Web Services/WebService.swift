//
//  WebService.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

typealias DefaultWebServiceCompletion = (Result<Data, WebServiceError>) -> ()
typealias NoResponseWebServiceCompletion = (Result<Void, WebServiceError>) -> ()
typealias SearchWebServiceCompletion = (Result<[SearchResult], WebServiceError>) -> ()

protocol WebServiceProtocol {
    func fetchImageDataList(searchText: String, completion: @escaping SearchWebServiceCompletion)
    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion)
}

protocol HasWebService {
    var webService: WebServiceProtocol { get }
}

class WebService: WebServiceProtocol {
    
    private var urlSession: URLSession
    private var cache: CacheManagerProtocol
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        self.cache = CacheManager.shared
    }

    func fetchImageDataList(searchText: String, completion: @escaping SearchWebServiceCompletion) {
        // check if searchText exists in cache
        if let cachedData = cache.fetch(key: searchText.lowercased().trimWhiteSpace()),
           let searchResult = try? JSONDecoder().decode(SearchList.self, from: cachedData) {
            completion(.success(searchResult.searchList))
            return
        }
        
        var urlString = "\(Url.baseUrlString)\(Url.searchUrl)\(searchText)"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        fetchData(with: urlString) { [weak self] result in
    
            switch result {
            case .success(let data):
                do {
                    let searchResult = try JSONDecoder().decode(SearchList.self, from: data)
                    completion(.success(searchResult.searchList))
                    // Save response data to cache
                    self?.cache.save(key: searchText.lowercased().trimWhiteSpace(), data: data)
                } catch {
                    completion(.failure(.jsonDecodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
        
    }
    
    func fetchImageData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        // check if urlString exists in cache
        if let cachedData = cache.fetch(key: urlString) {
            completion(.success(cachedData))
            return
        }
        
        fetchData(with: urlString) { [weak self] result in
            if case let .success(data) = result {
                completion(.success(data))
                // Save response data to cache
                self?.cache.save(key: urlString, data: data)
            }
            completion(result)
        }
        
    }
    
    func fetchData(with urlString: String, completion: @escaping DefaultWebServiceCompletion) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let dataTask = urlSession.dataTask(with: url) { (data, httpUrlResponse, error) in
            
            guard error == nil else {
                return completion(.failure(.unableToCompleteRequest))
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(data))
        
        }
        
        dataTask.resume()
        
    }
}
