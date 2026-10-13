//
//  AusgabenApp.swift
//  AusgabenApp
//
//  Created by Lukas on 13.10.26.
//

import SwiftUI
import SwiftData

@main
struct AusgabenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Expense.self)
    }
}
