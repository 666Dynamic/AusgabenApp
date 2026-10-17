# AusgabenApp

Einfache iOS-App zum Erfassen von Ausgaben mit Monatsübersicht und Währungsumrechnung.
Abschlussprojekt des Moduls „Eigene iOS App".

## Funktionen
- Ausgaben erfassen, bearbeiten, löschen und durchsuchen (nach Monaten gruppiert)
- Monatsübersicht mit Diagramm und Summen pro Kategorie
- Aktuelle Wechselkurse (Frankfurter API) und Umrechnung in die Hauptwährung
- Einstellungen für die Hauptwährung

## Technik
- SwiftUI, `TabView`, `NavigationStack`, Sheet, `NavigationLink`, `List`
- SwiftData (`@Model`, `@Query`) für die lokale Speicherung
- MVVM mit `@Observable`
- `async/await` mit `URLSession`, getrennte Service-Schicht
- Swift Charts
- API: [Frankfurter](https://frankfurter.dev) (kostenlos, ohne API-Key)

## Technische Entscheidungen
Ich habe bewusst die aktuellen Apple-Frameworks verwendet:
- **SwiftData statt Core Data:** SwiftData ist der moderne Nachfolger von Core Data und
  bietet dieselbe lokale Offline-Speicherung mit deutlich weniger Code.
- **`@Observable` statt `ObservableObject`/`@Published`:** Die MVVM-Architektur bleibt
  erhalten, nutzt aber das Observation-Framework (iOS 17+).
- Es werden ausschließlich Standardkomponenten von Apple verwendet, damit die App den
  Human Interface Guidelines folgt.
