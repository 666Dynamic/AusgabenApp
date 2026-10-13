//
//  OverviewView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import SwiftUI
import SwiftData
import Charts

struct OverviewView: View {
    @Query private var expenses: [Expense]
    @AppStorage("defaultCurrency") private var defaultCurrency = "EUR"
    @State private var viewModel = OverviewViewModel()

    var body: some View {
        let totals = viewModel.categoryTotals(expenses, currencyCode: defaultCurrency)
        let excluded = viewModel.excludedCount(expenses, currencyCode: defaultCurrency)

        NavigationStack {
            List {
                Section {
                    HStack {
                        Button("Vorheriger Monat", systemImage: "chevron.left") {
                            viewModel.shiftMonth(by: -1)
                        }
                        Spacer()
                        Text(viewModel.selectedMonth, format: .dateTime.month(.wide).year())
                            .font(.headline)
                        Spacer()
                        Button("Nächster Monat", systemImage: "chevron.right") {
                            viewModel.shiftMonth(by: 1)
                        }
                        .disabled(!viewModel.canGoForward)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                }

                if totals.isEmpty {
                    ContentUnavailableView(
                        "Keine Ausgaben",
                        systemImage: "chart.pie",
                        description: Text("In diesem Monat gibt es nichts zu zeigen.")
                    )
                } else {
                    Section("Gesamt") {
                        Text(viewModel.total(expenses, currencyCode: defaultCurrency),
                             format: .currency(code: defaultCurrency))
                            .font(.largeTitle.bold())

                        Chart(totals) { item in
                            SectorMark(
                                angle: .value("Betrag", item.total),
                                innerRadius: .ratio(0.6),
                                angularInset: 1.5
                            )
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Kategorie", item.category.title))
                        }
                        .frame(height: 220)
                    }

                    Section("Nach Kategorie") {
                        ForEach(totals) { item in
                            LabeledContent {
                                Text(item.total, format: .currency(code: defaultCurrency))
                            } label: {
                                Label(item.category.title, systemImage: item.category.systemImage)
                            }
                        }
                    }
                }

                if excluded > 0 {
                    Section {
                        Text("\(excluded) Ausgaben konnten nicht umgerechnet werden, weil keine Kurse vorliegen.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Übersicht")
            .task(id: defaultCurrency) { await viewModel.loadRates(base: defaultCurrency) }
        }
    }
}

#Preview {
    OverviewView()
        .modelContainer(for: Expense.self, inMemory: true)
}
