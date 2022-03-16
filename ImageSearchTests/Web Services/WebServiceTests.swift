//
//  WebServiceTests.swift
//  ImageSearchTests
//
//  Created by Marc Jardine Esperas on 3/15/22.
//  Copyright © 2022 Marc Esperas. All rights reserved.
//

import XCTest

import ImageSearch

@testable import ImageSearch

class WebServiceTests: XCTestCase {

    var sut: WebService!
    
    override func setUp()  {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockUrlProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = WebService(urlSession: urlSession)
    }

    override func tearDown() {
        sut = nil
        MockUrlProtocol.stubResponseData = nil
    }
    
    func testFetchImageDataList_SuccessfulResponse() {
        let mockSearchResult = SearchResult(previewURL: "https://cdn.pixabay.com/photo/2016/01/08/05/24/sunflower-1127174_150.jpg")
        
        MockUrlProtocol.stubResponseData = readJsonFile(name: "ImageListResponse")
        
        let expectation = self.expectation(description: "Image list web service response expectation")
        
        sut.fetchImageDataList(searchText: "yellow flowers") { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, [mockSearchResult])
            case .failure(let error):
                XCTFail("Error fetching search image list: \(error)")
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func readJsonFile(name: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let bundlePath = bundle.path(forResource: name, ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: bundlePath ?? ""))
        return data
    }

}
