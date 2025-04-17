// main.swift
// Store
//
// Created by Ted Neward on 2/29/24.

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int  // Price in pennies (USD cents)
}

class Item: SKU {
    let name: String
    let priceEach: Int  // Price in pennies

    init(name: String, priceEach: Int) {
        self.name = name
        self.priceEach = priceEach
    }
    
    func price() -> Int {
        return priceEach
    }
}

class WeightBasedItem: SKU {
    let name: String
    let pricePerPound: Int  // Price per pound in pennies
    let weightInPounds: Double  // Weight of the item in pounds

    init(name: String, pricePerPound: Int, weightInPounds: Double) {
        self.name = name
        self.pricePerPound = pricePerPound
        self.weightInPounds = weightInPounds
    }

    func price() -> Int {
        let price = Double(pricePerPound) * weightInPounds
        return Int(price.rounded())  // Round the price to the nearest penny
    }
}

class Receipt {
    private var items: [SKU] = []

    func addItem(_ item: SKU) {
        items.append(item)
    }

    func total() -> Int {
        return items.reduce(0) { $0 + $1.price() }
    }

    func output() -> String {
        var result = "Receipt:\n"
        for item in items {
            result += "\(item.name): $\(String(format: "%.2f", Double(item.price()) / 100))\n"
        }
        let totalAmount = total()
        result += "------------------\nTOTAL: $\(String(format: "%.2f", Double(totalAmount) / 100))"
        return result
    }

    func itemsList() -> [String] {
        return items.map { $0.name }
    }
}

class Register {
    private var receipt: Receipt

    init() {
        self.receipt = Receipt()
    }

    func scan(_ sku: SKU) {
        receipt.addItem(sku)
    }

    func subtotal() -> Int {
        return receipt.total()
    }

    func total() -> Receipt {
        let finishedReceipt = receipt
        self.receipt = Receipt()  // Reset the receipt for the next transaction
        return finishedReceipt
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
