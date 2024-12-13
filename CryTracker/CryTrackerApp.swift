import SwiftUI
import SwiftData

@main
struct CryTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: CryLog.self) // Initialize SwiftData for the CryLog model
        }
    }
}
