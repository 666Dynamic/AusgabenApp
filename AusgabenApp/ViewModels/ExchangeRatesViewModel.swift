//
//  ExchangeRatesViewModel.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import Foundation
import Observation

@Observable
final class ExchangeRatesViewModel {
    enum LoadState {
        case loading
        case loaded(ExchangeRatesResponse)
        case failed(String)
    }

    var state: LoadState = .loading
    var baseCurrency = "EUR"
    var amountText = "1"

    private let service = ExchangeRateService()

    var amount: Double {
        (try? Double(amountText, format: .number)) ?? 0
    }

    func load() async {
        state = .loading
        do {
            let symbols = ExpenseFormView.currencies.filter { $0 != baseCurrency }
            let response = try await service.fetchRates(base: baseCurrency, symbols: symbols)
            state = .loaded(response)
        } catch {
            if Task.isCancelled { return }
            state = .failed(error.localizedDescription)
        }
    }
}