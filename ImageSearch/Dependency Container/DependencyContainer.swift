//
//  DependencyContainer.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

class DependencyContainer: HasWebService {
    static let shared = DependencyContainer()
    
    lazy var webService: WebServiceProtocol = {
        WebService()
    }()
}
