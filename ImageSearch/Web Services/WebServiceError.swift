//
//  WebServiceError.swift
//  ImageSearch
//
//  Created by Marc Jardine Esperas on 3/13/22.
//

import Foundation

enum WebServiceError: Error {
    
    case invalidUrl
    case unableToCompleteRequest
    case invalidResponse
    case invalidData
    case jsonDecodingError
    
    var title: String {
        switch self {
        default:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .unableToCompleteRequest:
            return "Unable to complete your request, please check your internet connection."
        case .invalidResponse:
            return "Invalid response from the server, please try again."
        case .invalidData:
            return "Unable to complete your request, please check your internet connection."
        case .jsonDecodingError:
            return "JSON Decoding Error"
        }
    }
}
