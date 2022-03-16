//
//  ImagesViewModel.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

class ImagesViewModel: HasWebService {
    let webService: WebServiceProtocol
    
    private let searchList: [SearchResult]
    
    init(dependencyContainer: DependencyContainer = DependencyContainer.shared,
         searchList: [SearchResult]) {
        self.webService = dependencyContainer.webService
        self.searchList = searchList
    }
    
    public func numberOfItemsInSection(_ section: Int) -> Int {
        return searchList.count
    }
    
    public func ImageAtIndex(_ index: Int) -> SearchResult {
        return searchList[index]
    }
    
    public func fetchImageData(with urlString: String?, completion: @escaping DefaultWebServiceCompletion) {
        webService.fetchImageData(with: urlString ?? "", completion: completion)
    }
}
