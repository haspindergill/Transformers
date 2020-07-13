//
//  APITests.swift
//  TransformersTests
//
//  Created by Haspinder Gill on 2020-07-12.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import XCTest
@testable import Transformers

var transformer = Transformer(courage: 5,
                              endurance: 5,
                              firepower: 5,
                              id: "testID",
                              intelligence: 5,
                              rank: 5,
                              skill: 5,
                              speed: 5,
                              strength: 5,
                              team: "A",
                              name: "testing",
                              teamIcon: "")

class APITests: XCTestCase {
    

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testACreateNewTransformer() {

        let expectation = self.expectation(description: "Create New Transformer")
        let errorExpectation = self.expectation(description: "Error")
        errorExpectation.isInverted = true
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CreateTransformer(transformer: transformer)) { (result) in
            switch result {
            case .Failure(_):
                errorExpectation.fulfill()
            case .Success(let transfor):
                guard let transfor = transfor as? Transformer else {
                    return
                }
                transformer = transfor
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testBUpdateTransformer() {
        let expectation = self.expectation(description: "Update New Transformer")
        let errorExpectation = self.expectation(description: "Error")
        errorExpectation.isInverted = true
        APIManager.sharedInstance.opertationWithRequest(withApi: API.EditTransformer(transformer: transformer)) { (result) in
            switch result {
            case .Failure(_):
                errorExpectation.fulfill()
            case .Success(_):
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCDeleteTransformer() {
        let expectation = self.expectation(description: "Delete New Transformer")
        let errorExpectation = self.expectation(description: "Error")
        errorExpectation.isInverted = true
        APIManager.sharedInstance.opertationWithRequest(withApi: API.DeleteTransformer(transformerID: transformer.id)) { (result) in
            switch result {
            case .Failure(_):
                errorExpectation.fulfill()
            case .Success(_):
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
