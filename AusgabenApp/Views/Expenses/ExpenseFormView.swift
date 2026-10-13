//
//  ExpenseFormView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import SwiftUI
import SwiftData

struct ExpenseFormView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    private let expense: Expense?

    @State private var title: String
    @State private var amount: Double?
    @State private var currencyCode: String
    @State private var date: Date
    @State private var category: ExpenseCategory
    @State private var note: String

    static let currencies = ["EUR", "PLN", "USD", "GBP", "CHF"]

    init(expense: Expense? = nil) {
        self.expense = expense
        _title = State(initialValue: expense?.title ?? "")
        _amount = State(initialValue: expense?.amount)
        _currencyCode = State(initialValue: expense?.currencyCode ?? "EUR")
        _date = State(initialValue: expense?.date ?? .now)
        _category = State(initialValue: expense?.category ?? .other)
        _note = State(initialValue: expense?.note ?? "")
    }

    private var canSave: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && (amount ?? 0) > 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Titel", text: $title)
                    TextField("Betrag", value: $amount, format: .number)
                        .keyboardType(.decimalPad)
                    Picker("Währung", selection: $currencyCode) {
                        ForEach(Self.currencies, id: \.self) { Text($0).tag($0) }
                    }
                }
                Section {
                    Picker("Kategorie", selection: $category) {
                        ForEach(ExpenseCategory.allCases) { category in
                            Label(category.title, systemImage: category.systemImage)
                                .tag(category)
                        }
                    }
                    DatePicker("Datum", selection: $date, displayedComponents: .date)
                }
                Section("Notiz") {
                    TextField("Optional", text: $note, axis: .vertical)
                        .lineLimit(3...)
                }
            }
            .navigationTitle(expense == nil ? "Neue Ausgabe" : "Ausgabe bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sichern") { save() }
                        .disabled(!canSave)
                }
            }
        }
    }

    private func save() {
        guard let amount else { return }
        if let expense {
            expense.title = title
            expense.amount = amount
            expense.currencyCode = currencyCode
            expense.date = date
            expense.category = category
            expense.note = note
        } else {
            modelContext.insert(Expense(
                title: title,
                amount: amount,
                currencyCode: currencyCode,
                date: date,
                category: category,
                note: note
            ))
        }
        dismiss()
    }
}