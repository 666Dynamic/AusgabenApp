//
//  SettingsView.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("defaultCurrency") private var defaultCurrency = "EUR"

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Hauptwährung", selection: $defaultCurrency) {
                        ForEach(ExpenseFormView.currencies, id: \.self) { Text($0).tag($0) }
                    }
                } footer: {
                    Text("In dieser Währung werden die Summen in der Übersicht angezeigt. Andere Währungen werden mit aktuellen Kursen umgerechnet.")
                }

                Section("Info") {
                    LabeledContent("Version", value: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0")
                    LabeledContent("Wechselkurse", value: "Frankfurter")
                }
            }
            .navigationTitle("Einstellungen")
        }
    }
}

#Preview {
    SettingsView()
}
