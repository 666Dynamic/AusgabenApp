//
//  ExchangeRatesView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import SwiftUI

struct ExchangeRatesView: View {
    @State private var viewModel = ExchangeRatesViewModel()

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            List {
                Section {
                    Picker("Basiswährung", selection: $viewModel.baseCurrency) {
                        ForEach(ExpenseFormView.currencies, id: \.self) { Text($0).tag($0) }
                    }
                    LabeledContent("Betrag") {
                        TextField("Betrag", text: $viewModel.amountText)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }

                switch viewModel.state {
                case .loading:
                    Section {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                case .loaded(let response):
                    Section {
                        ForEach(response.rates.sorted(by: { $0.key < $1.key }), id: \.key) { code, rate in
                            LabeledContent {
                                Text(viewModel.amount * rate, format: .currency(code: code))
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(code)
                                    Text("1 \(response.base) = \(rate.formatted(.number.precision(.fractionLength(2...4)))) \(code)")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    } header: {
                        Text("Umgerechnet")
                    } footer: {
                        if let date = try? Date(response.date, strategy: .iso8601.year().month().day()) {
                            Text("Stand: \(date.formatted(date: .long, time: .omitted))")
                        }
                    }
                case .failed(let message):
                    Section {
                        ContentUnavailableView {
                            Label("Kurse nicht verfügbar", systemImage: "wifi.slash")
                        } description: {
                            Text(message)
                        } actions: {
                            Button("Erneut versuchen") {
                                Task { await viewModel.load() }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Kurse")
            .task(id: viewModel.baseCurrency) { await viewModel.load() }
            .refreshable { await viewModel.load() }
        }
    }
}

#Preview {
    ExchangeRatesView()
}