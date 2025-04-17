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
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(199 + 99, register.subtotal())
    }

    // New test for verifying that scanning multiple identical items works properly
    func testMultipleIdenticalItems() {
        let pricePerItem = 299
        register.scan(Item(name: "Cookies (Pack of 6)", priceEach: pricePerItem))
        register.scan(Item(name: "Cookies (Pack of 6)", priceEach: pricePerItem))
        register.scan(Item(name: "Cookies (Pack of 6)", priceEach: pricePerItem))
        
        let expectedSubtotal = pricePerItem * 3
        XCTAssertEqual(expectedSubtotal, register.subtotal())
    }
    
    // New test for scanning multiple different items with different prices
    func testDifferentItemsMultipleTimes() {
        register.scan(Item(name: "Apples (1lb)", priceEach: 150))  // $1.50
        register.scan(Item(name: "Bananas (1lb)", priceEach: 120)) // $1.20
        register.scan(Item(name: "Chips (Bag)", priceEach: 250))   // $2.50
        register.scan(Item(name: "Soda (Can)", priceEach: 120))     // $1.20
        
        let expectedSubtotal = 150 + 120 + 250 + 120
        XCTAssertEqual(expectedSubtotal, register.subtotal())
    }
    
    // New test for checking subtotal with items in multiple transactions
    func testSubtotalAcrossMultipleTransactions() {
        register.scan(Item(name: "Bread", priceEach: 179)) // $1.79
        let receipt1 = register.total()
        XCTAssertEqual(179, receipt1.total())

        register.scan(Item(name: "Butter", priceEach: 299)) // $2.99
        let receipt2 = register.total()
        XCTAssertEqual(299, receipt2.total())

        register.scan(Item(name: "Cheese", priceEach: 499)) // $4.99
        let receipt3 = register.total()
        XCTAssertEqual(499, receipt3.total())

        // Ensuring the transaction resets with each call to total
        XCTAssertEqual(179, receipt1.total())
        XCTAssertEqual(299, receipt2.total())
        XCTAssertEqual(499, receipt3.total())
    }

    // New test for receipt output with no items
    func testEmptyReceiptOutput() {
        let receipt = register.total()
        let expectedOutput = """
        Receipt:
        ------------------
        TOTAL: $0.00
        """
        XCTAssertEqual(expectedOutput, receipt.output())
    }

    // New test for edge case of zero price
    func testZeroPriceItem() {
        register.scan(Item(name: "Free Item", priceEach: 0)) // $0.00
        XCTAssertEqual(0, register.subtotal())
    }
    
    // Extrea credit test for weighted items
    func testWeightBasedItem() {
        // Create a WeightBasedItem (e.g., a 1.5-pound steak at $8.99 per pound)
        let steak = WeightBasedItem(name: "Steak (1.5lb)", pricePerPound: 899, weightInPounds: 1.5)
        
        // Scan the item
        register.scan(steak)
        
        // Test subtotal after scanning the weight-based item
        let expectedSubtotal = 899 * 1.5  // This should be $13.485, rounded to $13.49
        XCTAssertEqual(1349, register.subtotal())
        
        // Get the receipt and check the output
        let receipt = register.total()
        XCTAssertEqual(1349, receipt.total())

        let expectedReceipt = """
        Receipt:
        Steak (1.5lb): $13.49
        ------------------
        TOTAL: $13.49
        """
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}
