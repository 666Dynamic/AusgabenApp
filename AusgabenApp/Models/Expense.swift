//
//  Expense.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var title: String
    var amount: Double
    var currencyCode: String
    var date: Date
    var category: ExpenseCategory
    var note: String

    init(
        title: String,
        amount: Double,
        currencyCode: String = "EUR",
        date: Date = .now,
        category: ExpenseCategory = .other,
        note: String = ""
    ) {
        self.title = title
        self.amount = amount
        self.currencyCode = currencyCode
        self.date = date
        self.category = category
        self.note = note
    }
}

enum ExpenseCategory: String, Codable, CaseIterable, Identifiable {
    case food, transport, housing, leisure, shopping, other

    var id: Self { self }

    var title: String {
        switch self {
        case .food: "Essen"
        case .transport: "Mobilität"
        case .housing: "Wohnen"
        case .leisure: "Freizeit"
        case .shopping: "Einkaufen"
        case .other: "Sonstiges"
        }
    }

    var systemImage: String {
        switch self {
        case .food: "fork.knife"
        case .transport: "car"
        case .housing: "house"
        case .leisure: "ticket"
        case .shopping: "bag"
        case .other: "ellipsis.circle"
        }
    }
}
