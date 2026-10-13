//
//  ExpenseDetailView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import SwiftUI

struct ExpenseDetailView: View {
    let expense: Expense
    @State private var showingEditSheet = false

    var body: some View {
        Form {
            Section {
                LabeledContent("Betrag") {
                    Text(expense.amount, format: .currency(code: expense.currencyCode))
                }
                LabeledContent("Kategorie") {
                    Label(expense.category.title, systemImage: expense.category.systemImage)
                }
                LabeledContent("Datum") {
                    Text(expense.date, format: .dateTime.day().month().year())
                }
            }
            if !expense.note.isEmpty {
                Section("Notiz") {
                    Text(expense.note)
                }
            }
        }
        .navigationTitle(expense.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Bearbeiten") { showingEditSheet = true }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            ExpenseFormView(expense: expense)
        }
    }
}