//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest

final class StoreTests: XCTestCase {

    var register: Register!

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
        Receipt:
        Beans (8oz Can): $1.99
        ------------------
        TOTAL: $1.99
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }

    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
    }

    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granola Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
        Receipt:
        Beans (8oz Can): $1.99
        Pencil: $0.99
        Granola Bars (Box, 8ct): $4.99
        ------------------
        TOTAL: $7.97
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testEmptyReceipt() {
        let receipt = register.total()
        XCTAssertEqual(0, receipt.total())

        let expectedReceipt = """
        Receipt:
        ------------------
        TOTAL: $0.00
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }

    func testTotalReset() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        let firstReceipt = register.total()
        XCTAssertEqual(199, firstReceipt.total())

        register.scan(Item(name: "Pencil", priceEach: 99))
        let secondReceipt = register.total()
        XCTAssertEqual(99, secondReceipt.total())

        let firstReceiptOutput = """
        Receipt:
        Beans (8oz Can): $1.99
        ------------------
        TOTAL: $1.99
        """
        XCTAssertEqual(firstReceiptOutput, firstReceipt.output())

        let secondReceiptOutput = """
        Receipt:
        Pencil: $0.99
        ------------------
        TOTAL: $0.99
        """
        XCTAssertEqual(secondReceiptOutput, secondReceipt.output())
    }

    func testSubtotalIntegrity() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        
        register.scan(Item(name: "Granola Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
    }

    func testReceiptFormat() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Pencil", priceEach: 99))
        
        let receipt = register.total()

        let expectedReceipt = """
        Receipt:
        Beans (8oz Can): $1.99
        Pencil: $0.99
        ------------------
        TOTAL: $2.98
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testLargeTotalAmount() {
        register.scan(Item(name: "Granola Bars (Box, 8ct)", priceEach: 499))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Pencil", priceEach: 99))
        register.scan(Item(name: "Notebook", priceEach: 1200))
        
        let receipt = register.total()
        XCTAssertEqual(199 + 99 + 499 + 1200, receipt.total())

        let expectedReceipt = """
        Receipt:
        Granola Bars (Box, 8ct): $4.99
        Beans (8oz Can): $1.99
        Pencil: $0.99
        Notebook: $12.00
        ------------------
        TOTAL: $19.97
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
}
