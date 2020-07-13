//
//  DatabaseTests.swift
//  TransformersTests
//
//  Created by Haspinder Gill on 2020-07-12.
//  Copyright © 2020 Haspinder Gill. All rights reserved.
//

import XCTest
@testable import Transformers


class DatabaseTests: XCTestCase {

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
                                    name: "",
                                    teamIcon: "")
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testAddTransformerToList() {
        DataManager.sharedInstance.storeTransformerInDatabase(transformers: [transformer])
        XCTAssert(DataManager.sharedInstance.getListOfTransformers().count > 1)
    }
    
    func testDelete() {
        let items = DataManager.sharedInstance.getListOfTransformers()
        DataManager.sharedInstance.deleteTransformer(withID: transformer.id)
        XCTAssertNotEqual(DataManager.sharedInstance.getListOfTransformers().count, items.count)
    }

}
