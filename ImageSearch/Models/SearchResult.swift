//
//  SearchResult.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

struct SearchList: Decodable {
    let searchList: [SearchResult]
    
    enum CodingKeys: String, CodingKey {
        case searchList = "hits"
    }
}

struct SearchResult: Decodable {
    let previewURL: String
}

extension SearchResult: Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.previewURL == rhs.previewURL
    }
}
