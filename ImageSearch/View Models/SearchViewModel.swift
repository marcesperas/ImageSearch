//
//  SearchViewModel.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

protocol SearchViewModelProtocol {
    var searchText: String { get set }
    init(dependencyContainer: DependencyContainer)
    func isSearchButtonEnabled() -> Bool
    func fetchImageDataList(completion: @escaping SearchWebServiceCompletion)
}

class SearchViewModel: SearchViewModelProtocol, HasWebService {
    
    var searchText: String = ""
    
    let webService: WebServiceProtocol
    
    required init(dependencyContainer: DependencyContainer = DependencyContainer.shared) {
        self.webService = dependencyContainer.webService
    }
    
    func isSearchButtonEnabled() -> Bool {
        return !searchText.isEmpty
    }
    
    func fetchImageDataList(completion: @escaping SearchWebServiceCompletion) {
        webService.fetchImageDataList(searchText: searchText, completion: completion)
    }
}
