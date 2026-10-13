//
//  ContentView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Ausgaben", systemImage: "list.bullet") {
                ExpenseListView()
            }
            Tab("Übersicht", systemImage: "chart.pie") {
                OverviewView()
            }
            Tab("Kurse", systemImage: "eurosign.circle") {
                ExchangeRatesView()
            }
            Tab("Einstellungen", systemImage: "gearshape") {
                SettingsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Expense.self, inMemory: true)
}

