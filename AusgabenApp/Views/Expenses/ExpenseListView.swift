//
//  ExpenseListView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import SwiftUI
import SwiftData

struct ExpenseListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Expense.date, order: .reverse) private var expenses: [Expense]

    @State private var searchText = ""
    @State private var showingAddSheet = false

    private var filteredExpenses: [Expense] {
        guard !searchText.isEmpty else { return expenses }
        return expenses.filter { $0.title.localizedStandardContains(searchText) }
    }

    private var monthGroups: [(month: Date, items: [Expense])] {
        let grouped = Dictionary(grouping: filteredExpenses) {
            Calendar.current.dateInterval(of: .month, for: $0.date)?.start ?? $0.date
        }
        return grouped.keys.sorted(by: >).map { ($0, grouped[$0] ?? []) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if expenses.isEmpty {
                    ContentUnavailableView(
                        "Noch keine Ausgaben",
                        systemImage: "tray",
                        description: Text("Tippe auf +, um deine erste Ausgabe zu erfassen.")
                    )
                } else {
                    List {
                        ForEach(monthGroups, id: \.month) { group in
                            Section(group.month.formatted(.dateTime.month(.wide).year())) {
                                ForEach(group.items) { expense in
                                    NavigationLink(value: expense) {
                                        ExpenseRow(expense: expense)
                                    }
                                }
                                .onDelete { offsets in
                                    delete(offsets, from: group.items)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText, prompt: "Ausgaben suchen")
                }
            }
            .navigationTitle("Ausgaben")
            .navigationDestination(for: Expense.self) { expense in
                ExpenseDetailView(expense: expense)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Hinzufügen", systemImage: "plus") {
                        showingAddSheet = true
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                ExpenseFormView()
            }
        }
    }

    private func delete(_ offsets: IndexSet, from items: [Expense]) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
}

struct ExpenseRow: View {
    let expense: Expense

    var body: some View {
        HStack {
            Label(expense.title, systemImage: expense.category.systemImage)
            Spacer()
            Text(expense.amount, format: .currency(code: expense.currencyCode))
                .foregroundStyle(.secondary)
        }
    }
}
