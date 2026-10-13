//
//  OverviewViewModel.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import Foundation
import Observation

struct CategoryTotal: Identifiable {
    let category: ExpenseCategory
    let total: Double
    var id: ExpenseCategory { category }
}

@Observable
final class OverviewViewModel {
    var selectedMonth: Date = Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now

    private(set) var rates: [String: Double] = [:]
    private(set) var ratesBase = ""
    private let service = ExchangeRateService()

    private var currentMonthStart: Date {
        Calendar.current.dateInterval(of: .month, for: .now)?.start ?? .now
    }

    var canGoForward: Bool { selectedMonth < currentMonthStart }

    func shiftMonth(by value: Int) {
        selectedMonth = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) ?? selectedMonth
    }

    // MARK: - Kurse

    func loadRates(base: String) async {
        let symbols = ExpenseFormView.currencies.filter { $0 != base }
        do {
            let response = try await service.fetchRates(base: base, symbols: symbols)
            rates = response.rates
            ratesBase = base
        } catch {
            // Ohne Kurse bleiben Fremdwährungen ausgeschlossen (siehe excludedCount)
        }
    }

    /// Betrag in der Hauptwährung oder nil, wenn kein Kurs vorliegt
    private func converted(_ expense: Expense, to code: String) -> Double? {
        if expense.currencyCode == code { return expense.amount }
        guard ratesBase == code, let rate = rates[expense.currencyCode], rate > 0 else { return nil }
        return expense.amount / rate
    }

    // MARK: - Auswertung

    private func expensesInMonth(_ all: [Expense]) -> [Expense] {
        guard let interval = Calendar.current.dateInterval(of: .month, for: selectedMonth) else { return [] }
        return all.filter { interval.contains($0.date) }
    }

    private func convertible(_ all: [Expense], currencyCode: String) -> [(expense: Expense, value: Double)] {
        expensesInMonth(all).compactMap { expense in
            converted(expense, to: currencyCode).map { (expense, $0) }
        }
    }

    func excludedCount(_ all: [Expense], currencyCode: String) -> Int {
        expensesInMonth(all).count - convertible(all, currencyCode: currencyCode).count
    }

    func total(_ all: [Expense], currencyCode: String) -> Double {
        convertible(all, currencyCode: currencyCode).reduce(0) { $0 + $1.value }
    }

    func categoryTotals(_ all: [Expense], currencyCode: String) -> [CategoryTotal] {
        let grouped = Dictionary(grouping: convertible(all, currencyCode: currencyCode), by: { $0.expense.category })
        return grouped
            .map { CategoryTotal(category: $0.key, total: $0.value.reduce(0) { $0 + $1.value }) }
            .sorted { $0.total > $1.total }
    }
}
